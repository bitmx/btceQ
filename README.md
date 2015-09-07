
This is an implementation of [BTCE](https://btc-e.com) trading and public [api](https://btc-e.com/tapi/docs).

To build -

```
$ git clone https://github.com/bitmx/btceQ.git
$ cd btceQ
$ make
$ export BTC_HOME=<INSTALL_PATH>/btceQ

```

This will build 32bit shared objects for http.c and hmac512.cpp. For 64 bit please update -m32 to -m64 in c/MakeFile. If you are bulding on a 64bit system to bind with 32 bit kdb, make sure you have the 32bit versions of stdlib available.

To load the functions -
```
$ q q/xlayer/btc.q
```
The functions are in .btc namespace. For trading, an API key and API secret will need to be setup. Once you have the keys you can update API_KEY and API_SECRET variables in q/xlayer/btc.q

For querying the trade and depth data, the public api is used and doesn't require the API to be set up.

for eg -
```
$ q q/xlayer/btc.q
q).btc.getDepth[]
time                    ask     asize      bid     bsize      lvl ex  
----------------------------------------------------------------------
2015.09.07T12:14:44.062 238.678 0.012051   238.413 1e-08      00  btce
2015.09.07T12:14:44.062 238.811 0.015      238.219 0.025047   01  btce
2015.09.07T12:14:44.062 238.813 0.015      237.781 0.04129576 02  btce
2015.09.07T12:14:44.062 238.839 0.03       237.78  1          03  btce
2015.09.07T12:14:44.062 238.843 4.015      237.772 0.794      04  btce
2015.09.07T12:14:44.062 238.922 3.02205    237.77  0.0249     05  btce
2015.09.07T12:14:44.062 239     5.0249     237.75  4.512199   06  btce
2015.09.07T12:14:44.062 239.022 1.438      237.741 0.014375   07  btce
2015.09.07T12:14:44.062 239.179 1.419      237.74  32.68576   08  btce
2015.09.07T12:14:44.062 239.197 0.0208     237.737 0.035039   09  btce
2015.09.07T12:14:44.062 239.209 0.02821459 237.736 2.31       0a  btce
2015.09.07T12:14:44.062 239.222 0.040482   237.733 0.02320865 0b  btce
2015.09.07T12:14:44.062 239.336 1.18       237.7   0.01004    0c  btce
2015.09.07T12:14:44.062 239.422 0.02504    237.699 0.02834748 0d  btce
2015.09.07T12:14:44.062 239.433 0.019      237.686 0.01135    0e  btce
2015.09.07T12:14:44.062 239.434 0.016      237.665 0.1527025  0f  btce
2015.09.07T12:14:44.062 239.492 0.012504   237.664 0.243031   10  btce
....
```

any suggestions/questions please email - pawan.singh18@gmail.com


