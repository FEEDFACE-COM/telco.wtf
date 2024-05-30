
## WTF, Telco?!

`telco.wtf` is a lookup tool for acronyms and abbreviations used in the telecommunications industry. It is provided as a web service, DNS zone and command line tool. 

### Usage


* HTTP Request

		$ curl telco.wtf/mno
		# WTF, Telco?!
		MNO - Mobile Network Operator

* Command Line Tool

		$ ./wtf mno
		# WTF, Telco?!
		MNO - Mobile Network Operator

* DNS Zone query

		$ dig +short txt mno.telco.wtf
		"Mobile Network Operator"
	    

* Web Browser

	<http://telco.wtf/mno>
  >
  >  **WTF, Telco?!** 
  >  
  >  ---
  >
  >  * **MNO** - Mobile Network Operator
  >  


* Bash Shortcuts

		wtf(){ curl http://telco.wtf/$1; }                  # http
		wtf(){ dig -t txt +domain=telco.wtf +short $1; }    # dns



### Sources

  * ETSI ES 203 700
  * ETSI ETS 300 009-2
  * ETSI GS NFV-REL 001
  * ETSI TR 102 140
  * ETSI TR 102 198
  * ETSI TR 102 314-3
  * ETSI TR 121 905
  * ETSI TR 129 949
  * ETSI TS 101 441
  * ETSI TS 102 113-1
  * ETSI TS 102 250-2
  * ETSI TS 103 247
  * ETSI TS 103 397
  * ETSI TS 103 859
  * ETSI TS 110 174-2-2
  * ETSI TS 122 261
  * ETSI TS 123 060
  * ETSI TS 123 078
  * ETSI TS 123 228
  * ETSI TS 123 251
  * ETSI TS 123 256
  * ETSI TS 123 273
  * ETSI TS 123 501
  * ETSI TS 124 301
  * ETSI TS 124 523
  * ETSI TS 128 530
  * ETSI TS 129 007
  * ETSI TS 129 060
  * ETSI TS 129 214
  * ETSI TS 129 272
  * ETSI TS 129 274
  * ETSI TS 129 281
  * ETSI TS 129 338
  * ETSI TS 133 310
  * ETSI TS 133 320
  * ETSI TS 133 401
  * ETSI TS 133 501
  * ETSI TS 136 101
  * ETSI TS 138 331
  * ETSI TS 138 412


---

\# WTF, Telco?! v1.0.7-1-g8ede212 FEEDFACE.COM 2024-05

