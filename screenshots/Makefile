screenshots: DW-ANKHMORPORK.png DW-DISCWORLD.png

%.png: %.bmp
	convert $< $@
	for bmpfile in $(wildcard $(basename $<)-*.bmp) ; do \
		composite $< $$bmpfile -compose change-mask $$bmpfile.diff.png ; \
		composite $$bmpfile.diff.png $@ $@ ; \
		rm $$bmpfile.diff.png ; \
	done