


SPECS    ?= $(shell find ETSI -type f | sort |sed -e 's/ /\\ /g') credz
SERIAL   ?= $(shell date +%s)
VERSION  ?= $(shell git describe --tags)
DATE     ?= $(shell date +%Y-%m)


all: clean zone cgi
zone: zone/telco.wtf
cgi: cgi/wtf
cli: cli/wtf

help:
	@echo "## telco.wtf"
	@echo " make info      # show info"
	@echo " make zone      # assemble zone file"
	@echo " make cgi       # compile cgi service"
	@echo " make cli       # compile cli tool"
	@echo " make check     # verify zone file"      



zone/telco.wtf: SOA ${SPECS}
	cat SOA | sed "s/xxxxxxxxxx/${SERIAL}/" >| ./zone/telco.wtf
	echo 'wtf\t IN TXT "WTF, Telco?! v${VERSION} FEEDFACE.COM ${DATE}"\n\n\n' | pr -t -e16 >> ./zone/telco.wtf 
	for spec in ${SPECS}; do \
      head -3 "$$spec" | egrep "^;;"; echo;  \
      cat "$$spec" | awk -f zone.awk | pr -t -e16; \
      echo; echo; echo; \
    done >> ./zone/telco.wtf

cgi/wtf: wtf.go telco.go
	CGO_ENABLED=0 go build \
      -ldflags "-X main.VERSION=${VERSION} -X main.DATE=${DATE} \
                -linkmode 'external' -extldflags '-static' " \
      -o cgi/wtf wtf.go telco.go

cli/wtf: wtf.go telco.go
	CGO_ENABLED=0 go build \
      -ldflags "-X main.VERSION=${VERSION} -X main.DATE=${DATE}" \
      -o cli/wtf wtf.go telco.go \

telco.go: ${SPECS}
	echo "package main;" >| telco.go
	echo "var telco = []struct{k,v string} {\n" >> telco.go 
	for spec in ${SPECS}; do \
      head -3 "$$spec" | egrep "^;;" | sed 's.;;.//.g'; echo;  \
      cat "$$spec" | awk -f cgi.awk | pr -t -e16; \
      echo; echo; \
    done >> ./telco.go
	echo "}\n" >> ./telco.go


deploy: zone cgi
	cp -f zone/telco.wtf /var/nsd/zones/master/telco.wtf
	cp -f cgi/wtf /var/www/htdocs/telco.wtf/cgi-bin/telco.wtf


run: wtf.go telco.go
	go run wtf.go telco.go

clean:
	rm -f telco.go zone/telco.wtf cgi/wtf cli/wtf

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
	named-checkzone telco.wtf ./zone/telco.wtf

touch:
	touch ${SPECS} 

.PHONY: help info zone cgi clean check touch run all
