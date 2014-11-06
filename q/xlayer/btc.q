value "\\l ",getenv[`BTC_HOME],"/q/common/dcrypto.q"
value "\\l ",getenv[`BTC_HOME],"/q/common/dhttp.q"
value "\\l ",getenv[`BTC_HOME],"/q/common/dtime.q"
value "\\l ",getenv[`BTC_HOME],"/q/common/json.k"
value "\\l ",getenv[`BTC_HOME],"/q/common/dlog.q"

\d .btc

API_KEY:"YOUR-KEY-GOES-HERE"
API_SECRET:`$"your api secret goes here"
API_URL:`$"https://btc-e.com/tapi"
LAST_EXEC_ID : 0j

roundPrice : {[side;price] 0.001 * $[side=`Buy; floor price * 1000; ceiling price * 1000] }

apiCall:{[params]
        .http.urlReq[
                        API_URL;
                        params;
                        `$"Key:",API_KEY,"|",
                          "Sign:",raze string .crypto.hmac512[params;.btc.API_SECRET]
                ]
 }

getLatestNonce:{
      	params:`$"method=getInfo",
                 "&nonce=0";
      	res:apiCall params;
	.[`NONCE;();-1 + "I"$last ":" vs (.j.k res)`error];
	.log.Info "SETTING NONCE to ",string NONCE;
 }

getNonce:{
        NONCE::NONCE+1; :string NONCE
 }

getDigest:{[param;k]
	.crypto.hmac512[param;k]
 }

getInfo:{
	params:`$"method=getInfo",
		"&nonce=",getNonce[];
	res:.j.k apiCall params;
	res`return
 }

getTradeHistory:{
        params:`$"method=TradeHistory",
		"&nonce=",getNonce[];
        res:.j.k apiCall params;
        update timestamp:.time.unix2QTime[timestamp] from value res`return
 }

getLastExecID : {
	params:`$"method=TradeHistory",
		 "&count=1",
		 "&nonce=",getNonce[];
	res:.j.k apiCall params;
	.[`LAST_EXEC_ID;();:;res:"J"$string first key res`return];
	.log.Info "Initialized last execution id to ",string[res];
	res
 }

getExecutions : {
    	 params:`$"method=TradeHistory",
                 "&from_id=",string[LAST_EXEC_ID-100000],
                 "&nonce=",getNonce[];
        res:.j.k apiCall params;
	res:res`return;
	$[res~0n;0n;-1_(enlist enlist[`exec_key]!key[res]),'value res]

 }

getTransHistory:{
        params:`$"method=TransHistory",
		"&nonce=",getNonce[];
        res:.j.k apiCall params;
        value res`return
 }

trade:{[pair;typ;price;qty]
	price : roundPrice[typ;price];
	params:`$"method=Trade",
		"&pair=",string[pair],
		"&type=",string[typ],
		"&rate=",string[price],
		"&amount=",string[qty],
		"&nonce=",getNonce[];
	res:.j.k apiCall params;
	if[1f~res`success;
		.log.Info "Placed order for ",-3!(pair;typ;price;qty);
		 oid:`long$res[`return;`order_id];
		 :enlist `time`order_id`pair`event`side`price`qty!(.z.Z;oid;pair;`new;typ;price;qty)
	];
	.log.Info "Failed to place order for ",-3!(pair;typ;price;qty);
	0n	
 }

cancelOrder:{[order_id] 
	params:`$"method=CancelOrder",
		"&order_id=",string[order_id],
		"&nonce=",getNonce[];
	res : .j.k apiCall params;
        if[1f~res`success;
                .log.Info "Cancelled order - ",string[order_id];
                 oid:`long$res[`return;`order_id];
                 :enlist `time`order_id`pair`event`side`price`qty!(.z.Z;oid;`;`cancelled;`;0f;0f)
        ];
        .log.Info "Failed to Cancel order - ",string[order_id];
        0n
 }

cancelAllOrders:{
	a:getActiveOrders[];
	if[0n~a; 
		.log.Info "Nothing to cancel";
		:0n;
	];
	cancelOrder each a`order_id
 }

getActiveOrders:{
        params:`$"method=ActiveOrders",
		 "&nonce=",getNonce[];
        res:.j.k apiCall params;
        r:res`return;
	if[not 0n~r;
		r:`order_id xcols update order_id:(key r), timestamp_created:.time.unix2QTime[timestamp_created] from value r;
	];
	r
 }

getTrades:{
	r:.j.k .http.urlReq[`$"https://btc-e.com/api/2/btc_usd/trades";`;`];
        update date:.time.unix2QTime[date],ex:`btce from r
 }

getDepth:{
	r:.j.k .http.urlReq[`$"https://btc-e.com/api/2/btc_usd/depth";`;`];
	r:update time:.z.Z, ask:asks[;0], asize:asks[;1], bid:bids[;0], bsize:bids[;1] from flip r;
	update lvl:`byte$i,ex:`btce from delete asks,bids from r	
 }

/getLatestNonce[];
/getLastExecID[];

\d .
