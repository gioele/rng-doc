docs_xml     := $(patsubst %.rng,%.html,$(wildcard *.rng))
docs_compact := $(patsubst %.rnc,%.html,$(wildcard *.rnc))
docs := $(docs_xml) $(docs_compact)

SAXON := java -cp support/saxon9he.jar net.sf.saxon.Transform -t
DB_XSL := /usr/share/xml/docbook/stylesheet/docbook-xsl-ns/xhtml-1_1/docbook.xsl

all: $(docs)

%.html: %.docbook
	$(SAXON) -s:$< -xsl:$(DB_XSL) -o:$@

%.docbook: %.rng
	$(SAXON) -s:$< -xsl:rng-doc.xsl -o:$@

%.rng: %.rnc
	trang $< $@

clean:
	rm $(docs)

.PHONY: all clean
