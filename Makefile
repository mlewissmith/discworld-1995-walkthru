default: help

BASENAME = dw
SRCFILE = $(BASENAME).ifm
PAPERSIZE = a4

################################################################################
# PRIMARY TARGETS
PSMAPFILE = $(BASENAME).map.ps
PDFMAPFILE = $(BASENAME).map.pdf

TASKFILE = $(BASENAME).tasks.txt
ITEMFILE = $(BASENAME).items.txt

RAWMAPFILE = $(BASENAME).map.raw
RAWTASKFILE = $(BASENAME).tasks.raw
RAWITEMFILE = $(BASENAME).items.raw

HTMLINDEXFILE = $(BASENAME)-index.html
MOBIFILE = $(BASENAME)-ebook.mobi
EPUBFILE = $(BASENAME)-ebook.epub

PSDOTFILE = $(BASENAME).dot.ps
PDFDOTFILE = $(BASENAME).dot.pdf
SVGDOTFILE = $(BASENAME).dot.svg
PNGDOTFILE = $(BASENAME).dot.png

IFMOPTS =
# IFMOPTS = "-S verbose"

.PHONY: map tasks items text dot pdfmap pdfdot rawmap rawtasks rawitems raw

map: $(PSMAPFILE)
tasks: $(TASKFILE)
items: $(ITEMFILE)
text:  $(TASKFILE) $(ITEMFILE)

rawmap: $(RAWMAPFILE)
rawtasks: $(RAWTASKFILE)
rawitems: $(RAWITEMFILE)
raw: $(RAWITEMFILE) $(RAWTASKFILE) $(RAWMAPFILE)

html: $(HTMLINDEXFILE) screenshots svgdot
mobi: $(MOBIFILE)
epub: $(EPUBFILE)


pdfmap: $(PDFMAPFILE)
dot: $(PSDOTFILE)
pdfdot: $(PDFDOTFILE)
svgdot: $(SVGDOTFILE)
pngdot: $(PNGDOTFILE)

%.tasks.txt: %.ifm
	@$(REPORT)
	ifm $(IFMOPTS) -t -f text -o $@ $<

%.items.txt: %.ifm
	@$(REPORT)
	ifm $(IFMOPTS) -i -f text -o $@ $<

%.map.raw: %.ifm
	@$(REPORT)
	ifm $(IFMOPTS) -m -f raw -o $@ $<
%.tasks.raw: %.ifm
	@$(REPORT)
	ifm $(IFMOPTS) -t -f raw -o $@ $<
%.items.raw: %.ifm
	@$(REPORT)
	ifm $(IFMOPTS) -i -f raw -o $@ $<

%-index.html: %.ifm
	@$(REPORT)
	ifm2html $<

%-ebook.mobi: %-index.html
	@$(REPORT)
	ebook-convert $< $@ --no-inline-toc
%-ebook.epub: %-index.html
	@$(REPORT)
	ebook-convert $< $@ --level1-toc="//h:h1" --level2-toc="//h:h2" --level3-toc="//h:h3"

%.map.ps: %.ifm
	@$(REPORT)
	ifm $(IFMOPTS) -m -f ps -o $@ $<

%.dot.dot: %.ifm
	@$(REPORT)
	ifm $(IFMOPTS) -t -f dot -o $@ $<
	sed -i \
		-e's:^\([[:space:]]*graph\)://\1:g' \
		-e's:^\([[:space:]]*rankdir\)://\1:g' \
		-e's:^\([[:space:]]*rotate\)://\1:g' \
		-e's:^\([[:space:]]*concentrate\)://\1:g' \
		$@

%.ps: %.dot
	@$(REPORT)
	dot -Tps -o $@ $<
%.svg: %.dot
	@$(REPORT)
	dot -Tsvg -o $@ $<
%.png: %.dot
	@$(REPORT)
	dot -Tpng -o $@ $<
%.pdf: %.dot
	@$(REPORT)
	dot -Tpdf -o $@ $<

%.pdf: %.ps
	@$(REPORT)
	ps2pdf -sPAPERSIZE=$(PAPERSIZE) $< $@



.PHONY: screenshots
SCREENSHOTS=DW-ANKHMORPORK.png DW-DISCWORLD.png DW-LSPACE.png
$(SCREENSHOTS):
	$(MAKE) -C screenshots $@
	cp screenshots/$@ $@
screenshots: $(SCREENSHOTS)

################################################################################
# CLEANUP
.PHONY: clean
clean:
	@rm -fv $(PDFMAPFILE) $(PSMAPFILE)
	@rm -fv $(TASKFILE) $(ITEMFILE)
	@rm -fv $(RAWTASKFILE) $(RAWITEMFILE) $(RAWMAPFILE)
	@rm -fv $(PSDOTFILE) $(PDFDOTFILE)
	@rm -fv *~ core.* *.stackdump


.PHONY: help
help:
	@echo
	@echo "TARGETS"
	@echo "   screenshots"
	@echo "   html"
	@echo "   (pdf)map"
	@echo "   tasks"
	@echo "   items"
	@echo "   rec"
	@echo "   (pdf|svg|png)dot"
	@echo "   (pdf|ebub|mobi)book"
	@echo
## a handy macro
REPORT=echo -e '\n\n======== Making $@ ========\n'


################################################################################



