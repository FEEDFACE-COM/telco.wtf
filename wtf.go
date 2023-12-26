package main

import (
    "fmt"
    "os"
    "strings"
    "text/template"
    "html"
    "sort"
)


func Debug(format string, args ...interface{}) { fmt.Fprintf(os.Stderr,format+"\n", args...) }
func Error(format string, args ...interface{}) { fmt.Fprintf(os.Stderr,"WTF: "+format+"\n", args...); os.Exit( -1 ) }

type set map[string]bool
type res struct{Key string; Set set}

const HTML = 
`<html><head>
<title>WTF, Telco?!</title>
</head><body>
<h2>WTF, Telco?!</h2><hr>
{{- $length := len .Result }}
{{- if eq .Query "wtf" }}
    <strong>WTF, Telco?!</strong> {{ .Version }}
{{- else if eq $length 0 }}
    <em>{{ .Query }}</em> undefined.
{{- else }}
    <ul>
    {{- range $res := .Result -}}
        {{- range $val,$s := $res.Set }}
        <li><strong>{{$res.Key}}</strong> - {{$val}}</li>
        {{- end }}
    {{- end }}
    </ul>
{{- end }}
</body></html>
`

func version() string {
    return fmt.Sprintf("v%s FEEDFACE.COM %s",VERSION,DATE)
}

func main() {

    var HTTP = strings.Contains(os.Getenv("GATEWAY_INTERFACE"), "CGI")

    var query string = ""

    if HTTP {
        query = os.Getenv("QUERY_STRING")
    } else if len(os.Args) > 1 {
        query = os.Args[1]
    }
    
    if strings.ContainsAny(query,"\"\n\t\r\\") {
        Error("weird query: %s",query)
    }
    
    var result = make( map[string]set )
    
    q := strings.ToUpper(strings.ReplaceAll(query,"-",""))
    for _,entry := range telco {
        key,val := entry.k, entry.v
        k := strings.ToUpper(strings.ReplaceAll(key,"-",""))
        
        if q == "" || strings.EqualFold(k,q) || ( len(q) >= 4 && strings.Contains(k,q) ) {
            if _, ok := result[ key ]; ok {
                result[ key ][ val ] = true
            } else {
                result[ key ] = set{ val: true }
            }
        }
    }

    sorted := []res{}
    for k,s := range result {
        sorted = append(sorted, res{Key: k, Set: s} )
    }
    sort.Slice(sorted, func(i,j int) bool {
        a,b := sorted[i], sorted[j]
        return strings.ToUpper(a.Key) < strings.ToUpper(b.Key)
    })
  
    if HTTP {
        fmt.Printf("X-Powered-by: FEEDFACE.COM\n")
    }

    accept := os.Getenv("HTTP_ACCEPT")
    if HTTP && strings.Contains( accept, "text/html" ) {

        fmt.Printf("Content-Type: text/html\n\n")
   
        tmpl, err := template.New("html").Parse( HTML )
        if err != nil {
            Error("fail %s", err.Error() )
        }
        query := html.EscapeString( query )
        err = tmpl.Execute( os.Stdout, struct{Result []res; Query,Version string}{sorted,query,version()} )
        if err != nil {
            Error("fail %s", err.Error() )
        }
        
    } else {
        
        if HTTP {
            fmt.Printf("Content-Type: text/plain\n\n")
        }

        if query == "wtf" {
            fmt.Printf("# WTF, Telco?! %s\n",version())
        } else if len(sorted) <= 0 {
            fmt.Printf("# WTF, Telco?! <%s> undefined.\n",query)
        } else {
            fmt.Printf("# WTF, Telco?!\n")
        }
        for _,s := range sorted {
            key,set := s.Key, s.Set
            for val,_ := range set {
                fmt.Printf("%s - %s\n",key,val)
            }
        } 
    

    }

    os.Exit(0)
}


