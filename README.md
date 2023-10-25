
## WTF, Telco?!

`telco.wtf` is a DNS zone, web service and command line tool for looking up the many acronyms and abbreviations in use in the telecommunications industry. 

### Usage

* DNS query

		$ dig +short txt mno.telco.wtf
		"Mobile Network Operator"
	    

* HTTP request, accept text/plain

		$ curl telco.wtf/mvno
		# WTF, Telco?!
		MVNO - Mobile Virtual Network Operator


* Local executable

		$ ./wtf mcc
		# WTF, Telco?!
		MCC - Mobile Country Code


* Web browser

	<http://telco.wtf/mnc>
  >
  >  **WTF, Telco?!** 
  >  
  >  * **MNC** - Mobile Network Code
  >  


* bash alias

		alias wtf='dig -t txt +domain=telco.wtf +short' # dns
		wtf(){ curl http://telco.wtf/$1; }              # http



### Sources

  * ETSI ETS 300 009-2
  * ETSI TR 102 140
  * ETSI TR 102 198
  * ETSI TR 102 314-3
  * ETSI TR 121 905
  * ETSI TR 129 949
  * ETSI TS 101 441
  * ETSI TS 102 113-1
  * ETSI TS 102 250-2
  * ETSI TS 103 397
  * ETSI TS 122 261
  * ETSI TS 123 060
  * ETSI TS 123 078
  * ETSI TS 123 228
  * ETSI TS 123 251
  * ETSI TS 123 256
  * ETSI TS 123 501
  * ETSI TS 128 530
  * ETSI TS 129 007
  * ETSI TS 129 060
  * ETSI TS 129 272
  * ETSI TS 129 274
  * ETSI TS 129 281
  * ETSI TS 129 338
  * ETSI TS 133 310
  * ETSI TS 133 320
  * ETSI TS 133 401
  * ETSI TS 133 501
  * ETSI TS 136 101
  * ETSI TS 138 412



--

2023-10 FEEDFACE.COM

 



