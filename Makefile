


SPECS    ?= $(shell find ETSI -type f | sort |sed -e 's/ /\\ /g') credz
SERIAL   ?= $(shell date +%s)
VERSION  ?= $(shell git describe --tags)
DATE     ?= $(shell date +%Y-%m)


all: clean zone cgi
zone: telco.wtf
cgi: wtf-cgi
cli: wtf

help:
	@echo "## telco.wtf"
	@echo " make info      # show info"
	@echo " make zone      # assemble zone file"
	@echo " make cgi       # compile cgi service"
	@echo " make cli       # compile cli tool"
	@echo " make check     # verify zone file"      

rem:
	@echo 'pbpaste | for k in ABC ; do read line; echo "$$k $$line"; done'




telco.wtf: SOA ${SPECS}
	cat SOA | sed "s/xxxxxxxxxx/${SERIAL}/" >| ./telco.wtf
	echo 'wtf\t IN TXT "WTF, Telco?! v${VERSION} FEEDFACE.COM ${DATE}"\n\n\n' | pr -t -e16 >> ./telco.wtf 
	for spec in ${SPECS}; do \
      head -3 "$$spec" | egrep "^;;"; echo;  \
      cat "$$spec" | awk -f zone.awk | pr -t -e16; \
      echo; echo; echo; \
    done >> ./telco.wtf

wtf-cgi: wtf.go telco.go
	CGO_ENABLED=0 go build \
      -ldflags "-X main.VERSION=${VERSION} -X main.DATE=${DATE} \
                -linkmode 'external' -extldflags '-static' " \
      -o wtf-cgi wtf.go telco.go

wtf: wtf.go telco.go
	CGO_ENABLED=0 go build \
      -ldflags "-X main.VERSION=${VERSION} -X main.DATE=${DATE}" \
      -o wtf wtf.go telco.go \

telco.go: ${SPECS}
	echo "package main;" >| telco.go
	echo "var telco = []struct{k,v string} {\n" >> telco.go 
	for spec in ${SPECS}; do \
      head -3 "$$spec" | egrep "^;;" | sed 's.;;.//.g'; echo;  \
      cat "$$spec" | awk -f cgi.awk | pr -t -e16; \
      echo; echo; \
    done >> ./telco.go
	echo "}\n" >> ./telco.go




run: wtf.go
	go run wtf.go telco.go

clean:
	rm -f telco.go telco.wtf wtf wtf-cgi

info:
	@echo "## telco.wtf\n"
	@all=0; for spec in ${SPECS}; do \
        cnt=$$(cat "$${spec}" | egrep "^[0-9a-zA-Z-].*" | wc -l ); \
        all=$$(( $$all + $$cnt )); \
        printf "%5d %s\n" "$$cnt" "$$spec";\
      done; \
      printf "\n%5d definitions\n" "$$all"; \
      uniq=$$(cat ${SPECS} | egrep "^[0-9a-zA-Z-].*" | sort | uniq | wc -l ); \
      printf "%5d unique\n" "$$uniq"; \


check: telco.wtf
	named-checkzone telco.wtf ./telco.wtf

touch:
	touch ${SPECS} 

.PHONY: help info zone cgi clean check touch run all
