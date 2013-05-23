rng-doc: Embed DocBook documentation in Relax NG schemas
========================================================

`rng-doc` is an XSLT stylesheet that extracts DocBook documentation
embedded in Relax NG schemas.


Usage
-----

First, the Relax NG schema must be annotated with DocBook tags. See the
`example.rng` and `example-compact.rnc` example files to learn how
to annotate the schema.

To generate the documentation just copy the schema to the directory and
run `make`. 

	$ make

The included Makefile will generate the HTML documentation of every
Relax NG schema present in the directory.


Author
------

* Gioele Barabucci <http://svario.it/gioele>


Licence
-------

This is free software released into the public domain (CC0 license).

See the `COPYING` file or <http://creativecommons.org/publicdomain/zero/1.0/>
for more details.
