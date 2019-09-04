outline: sources/s0_intro.md
	pandoc  -V mainfont='Palatino' \
			-V fontsize=12pt \
			-V geometry="margin=1in" \
			-s sources/s0_intro.md -o outline.pdf
test:
	rm -rf pack/
	mkdir pack
	mkdir pack/sources
	cp -r sources/* pack/sources/
pack: outline
	rm -rf pack/
	mkdir pack
	# sources/data/figs
	cp -r sources pack/sources
	rm -rf pack/sources/.ipynb_checkpoints
	cp -r data pack/data
	cp -r figs pack/figs
	######################### 
	# 			PDF 
	######################### 
	mkdir pack/pdf
	## Convert Markdown notes
	for MDFILE in $$(cd sources && ls *.md); \
	do \
	echo "\nConverting $$MDFILE to PDF"; \
	cd $$HOME/work/sources && \
	pandoc -V mainfont='Palatino' \
		   -V fontsize=12pt \
		   -V geometry="margin=1in" \
		   --metadata pagetitle="$$(echo $$MDFILE | sed "s/.md//")" \
		   --bibliography rmd.bib \
		   --filter pandoc-citeproc \
		   -s $$MDFILE \
		   -o $$(echo $$MDFILE | sed "s/.md/.pdf/"); \
	done;
	## Convert jupyter notebooks
	for NBFILE in $$(cd sources && ls *.ipynb); \
	do \
		echo "Converting $$NBFILE to PDF"; \
		cd $$HOME/work/sources && \
		jupyter nbconvert --to pdf $$NBFILE ; \
	done;	
	## Move them to pack
	mv sources/*.pdf pack/pdf/
	######################### 
	# 			HTML
	######################### 
	mkdir pack/html
	## Convert Markdown notes
	for MDFILE in $$(ls sources/*.md); \
	do \
	echo "Converting $$MDFILE to HTML"; \
	pandoc -V mainfont='Palatino' \
		   -V fontsize=12pt \
		   -V geometry="margin=1in" \
		   --metadata pagetitle="$$(echo $$MDFILE | sed "s/.md//")" \
		   --bibliography sources/rmd.bib \
		   --filter pandoc-citeproc \
		   -s $$MDFILE \
		   -o $$(echo $$MDFILE | sed "s/.md/.html/"); \
	done;
	## Convert jupyter notebooks
	for NBFILE in $$(ls sources/*.ipynb); \
	do \
		echo "Converting $$NBFILE to HTML"; \
		jupyter nbconvert --to html --output-dir sources $$NBFILE ; \
	done;	
	## Move them to pack
	mv sources/*.html pack/html/
	######################### 
	# 			R scripts
	######################### 
	mkdir pack/R
	mv sources/*.R pack/R/
	#				Package
	mv outline.pdf pack/outline.pdf
	cp LICENSE pack/LICENSE
	zip -r pack_new.zip pack
	mv pack_new.zip pack.zip
	rm -r pack

