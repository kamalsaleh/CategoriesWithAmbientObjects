all: doc test

doc: doc/manual.six

doc/manual.six: makedoc.g \
		PackageInfo.g \
		doc/Doc.autodoc \
		doc/ObjectsWithGenerators.bib \
		gap/*.gd gap/*.gi examples/*.g examples/doc/*.g
	        gap makedoc.g

clean:
	(cd doc ; ./clean)

test:	doc
	gap maketest.g

archive: test
	(mkdir -p ../tar; cd ..; tar czvf tar/ObjectsWithGenerators.tar.gz --exclude ".DS_Store" --exclude "*~" ObjectsWithGenerators/doc/*.* ObjectsWithGenerators/doc/clean ObjectsWithGenerators/gap/*.{gi,gd} ObjectsWithGenerators/{PackageInfo.g,README,COPYING,VERSION,init.g,read.g,makedoc.g,makefile,maketest.g} ObjectsWithGenerators/examples/*.g ObjectsWithGenerators/examples/doc/*.g)

WEBPOS=public_html
WEBPOS_FINAL=~/Sites/homalg-project/ObjectsWithGenerators

towww: archive
	echo '<?xml version="1.0" encoding="UTF-8"?>' >${WEBPOS}.version
	echo '<mixer>' >>${WEBPOS}.version
	cat VERSION >>${WEBPOS}.version
	echo '</mixer>' >>${WEBPOS}.version
	cp PackageInfo.g ${WEBPOS}
	cp README ${WEBPOS}/README.ObjectsWithGenerators
	cp doc/manual.pdf ${WEBPOS}/ObjectsWithGenerators.pdf
	cp doc/*.{css,html} ${WEBPOS}
	rm -f ${WEBPOS}/*.tar.gz
	mv ../tar/ObjectsWithGenerators.tar.gz ${WEBPOS}/ObjectsWithGenerators-`cat VERSION`.tar.gz
	rm -f ${WEBPOS_FINAL}/*.tar.gz
	cp ${WEBPOS}/* ${WEBPOS_FINAL}
	ln -s ObjectsWithGenerators-`cat VERSION`.tar.gz ${WEBPOS_FINAL}/ObjectsWithGenerators.tar.gz

