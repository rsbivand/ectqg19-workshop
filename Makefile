outline: sources/s0_intro.md
	pandoc  -V mainfont='Palatino' \
			-V fontsize=12pt \
			-V geometry="margin=1in" \
			-s sources/s0_intro.md -o outline.pdf
pack:
	mkdir pack
	# 			PDF
	mkdir pack/pdf
	## Convert Markdown notes
	for MDFILE in $(ls sources/*.md); \
	do \
		cd sources && pandoc -V mainfont='Palatino' \
							 -V fontsize=12pt \
							 -V geometry="margin=1in" \
							 -s $MDFILE -o ${$MDFILE/".md"/".pdf"}; \
	done
###### Convert jupyter notebooks
####cd sources && jupyter nbconvert --to pdf *.ipynb
####mv notebooks/*.pdf pack/pdf/
####cd notebooks && rm -fR -- */
###### Convert R notebooks
##### 			HTML
####mkdir pack/html
###### Convert Markdown notes
###### Convert jupyter notebooks
####cd notebooks && jupyter nbconvert --to html *.ipynb
####mv notebooks/*.html pack/html
###### Convert R notebooks
#####---
####mkdir pack/sources
####cp sources/*.ipynb pack/sources
####cp -r data pack/data
####cp -r figs pack/figs
####cp outline.pdf pack/outline.pdf
####cp LICENSE pack/LICENSE
####zip -r pack_new.zip pack
####mv pack_new.zip pack.zip
####rm -r pack
####rm outline.pdf

