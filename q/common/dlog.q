\d .log

.log.handle:0;


Info : { 
	    -1 ln:string[.z.Z], " INFO ", x;
	    if[not 0~.log.handle;
		 .log.handle ln,"\n";
	   ];

	}

Init: {[file]
	.log.handle :: hopen file;
 }


\d .
