


SPECS    ?= $(shell find ETSI GSMA -type f | sort | sed -e 's/ /\\ /g')
SERIAL   ?= $(shell date +%s)
VERSION  ?= $(shell git describe --tags)
DATE     ?= $(shell date +%Y-%m)


new: clean telco.go zone/telco.wtf readme
zone: zone/telco.wtf
cgi: cgi/wtf
cli: cli/wtf

help:
	@echo "## telco.wtf"
	@echo " make info      # show info"
	@echo " make zone      # generate zone file"
	@echo " make cgi       # compile cgi service"
	@echo " make cli       # compile cli tool"
	@echo " make readme    # generate README.md"
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
	CGO_ENABLED=1 go build \
      -ldflags "-linkmode 'external' -extldflags '-static' " \
      -o cgi/wtf wtf.go telco.go

cli/wtf: wtf.go telco.go
	CGO_ENABLED=0 go build \
      -o cli/wtf wtf.go telco.go \

telco.go: ${SPECS}
	echo "package main;" >| telco.go
	echo "var VERSION, DATE string = \"${VERSION}\", \"${DATE}\"" >> telco.go
	echo "var telco = []struct{k,v string} {\n" >> telco.go 
	for spec in ${SPECS} credz; do \
      head -3 "$$spec" | egrep "^;;" | sed 's.;;.//.g'; echo;  \
      cat "$$spec" | awk -f cgi.awk | pr -t -e16; \
      echo; echo; \
    done >> ./telco.go
	echo "}\n" >> ./telco.go


deploy: zone cgi
	cp -f cgi/wtf /var/www/htdocs/telco.wtf/cgi-bin/wtf
	cp -f zone/telco.wtf /var/nsd/zones/master/telco.wtf
	doas nsd-control reload telco.wtf


run: wtf.go telco.go
	go run wtf.go telco.go

clean:
	rm -f telco.go zone/telco.wtf cgi/wtf cli/wtf

readme:
	readme=$$(cat README.md | awk '//{print;}/### Sources/{exit;}') ;\
	(echo "$${readme}"; echo; \
	for spec in ${SPECS}; do printf "  * $$(echo $${spec} | sed -e 's:^.*/::g;s: -.*$$::g;' )\n"; done; \
	echo; echo; echo "---"; echo; echo "\\# WTF, Telco?! v${VERSION} FEEDFACE.COM ${DATE}"; echo; \
	) >| README.md



info:
	@echo "## telco.wtf\n"
	@all=0; for spec in ${SPECS} credz; do \
        cnt=$$(cat "$${spec}" | egrep "^[0-9a-zA-Z-].*" | wc -l ); \
        all=$$(( $$all + $$cnt )); \
        printf "%5d %s\n" "$$cnt" "$$spec";\
      done; \
      printf "\n%5d definitions\n" "$$all"; \
      uniq=$$(cat ${SPECS} | egrep "^[0-9a-zA-Z-].*" | sort | uniq | wc -l ); \
      printf "%5d unique\n" "$$uniq"; \


check: zone/telco.wtf
	named-checkzone telco.wtf ./zone/telco.wtf

touch:
	touch ${SPECS} 

.PHONY: help info readme zone cgi clean check touch run all deploy
