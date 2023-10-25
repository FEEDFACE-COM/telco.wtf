
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
>	**WTF, Telco?!** 
>
>  * **MNC** - Mobile Network Code
>  


* bash alias

		alias wtf='dig -t txt +domain=telco.wtf +short' # dns
		wtf(){ curl http://telco.wtf/$1; }              # http



### Sources

 * ETSI TR 121 905 V14.1.1 (2017-07)
 * ETSI TS 123 060 V14.3.0 (2017-05)
 * ETSI TS 123 501 V17.10.0 (2023-09)
 * ETSI TS 133 501 V17.11.1 (2023-10)
 * other ETSI ts/tr ...
 



