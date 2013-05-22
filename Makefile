docs := $(patsubst %.rng,%.html,$(wildcard *.rng))

SAXON := java -cp support/saxon9he.jar net.sf.saxon.Transform -t
DB_XSL := /usr/share/xml/docbook/stylesheet/docbook-xsl-ns/xhtml-1_1/docbook.xsl

all: $(docs)

%.html: %.docbook
	$(SAXON) -s:$< -xsl:$(DB_XSL) -o:$@

%.docbook: %.rng
	$(SAXON) -s:$< -xsl:rng-doc.xsl -o:$@

clean:
	rm $(docs)

.INTERMEDIATE: %.docbook

.PHONY: all clean
