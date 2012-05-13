# Just run
#   make clean all archives
# to get fresh and ready to deploy .tbz2 and .zip archives

MAKEOBJ ?= ./makeobj

DESTDIR  ?= simutrans
PAKDIR   ?= $(DESTDIR)/pak128.Britain
DESTFILE ?= simupak128.Britain

# Dirs for simutranslator
TR_DIRS :=

OUTSIDE :=
OUTSIDE += grounds
TR_DIRS += grounds

DIRS64 :=
DIRS64 += gui/gui64
TR_DIRS += gui

DIRS128 :=
DIRS128 += air
TR_DIRS += air
DIRS128 += attractions
TR_DIRS += attractions
DIRS128 += boats
TR_DIRS += boats
DIRS128 += bus
TR_DIRS += bus
DIRS128 += citybuildings
TR_DIRS += citybuildings
DIRS128 += citycars
TR_DIRS += citycars
DIRS128 += depots
TR_DIRS += depots
DIRS128 += goods
TR_DIRS += goods
DIRS128 += gui/gui128
DIRS128 += hq
TR_DIRS += hq
DIRS128 += industry
TR_DIRS += industry
DIRS128 += livery-trains
TR_DIRS += livery-trains
DIRS128 += london-underground
TR_DIRS += london-underground
DIRS128 += maglev
TR_DIRS += maglev
DIRS128 += narrowgauge
TR_DIRS += narrowgauge
DIRS128 += pedestrians
TR_DIRS += pedestrians
DIRS128 += smokes
TR_DIRS += smokes
DIRS128 += stations
TR_DIRS += stations
DIRS128 += townhall
TR_DIRS += townhall
DIRS128 += trains
TR_DIRS += trains
DIRS128 += trams
TR_DIRS += trams
DIRS128 += trees
TR_DIRS += trees
DIRS128 += ways
TR_DIRS += ways

DIRS192 := 
DIRS192 += boats/boats192
DIRS192 := 
DIRS192 += air/air192

DIRS224 := 
DIRS224 += boats/boats224


DIRS := $(OUTSIDE) $(DIRS64) $(DIRS128) $(DIRS192) $(DIRS224)


.PHONY: $(DIRS) copy tar zip simutranslator

all: copy $(DIRS)

archives: tar zip

tar: $(DESTFILE).tbz2
zip: $(DESTFILE).zip

$(DESTFILE).tbz2: $(PAKDIR)
	@echo "===> TAR $@"
	@tar cjf $@ $(DESTDIR)

$(DESTFILE).zip: $(PAKDIR)
	@echo "===> ZIP $@"
	@zip -rq $@ $(DESTDIR)

copy:
	@echo "===> COPY"
	@mkdir -p $(PAKDIR)/text $(PAKDIR)/text/citylists $(PAKDIR)/config
	@cp -p compat.tab $(PAKDIR)
	@cp -p config/* $(PAKDIR)/config
#	@mkdir -p $(PAKDIR)/sound $(PAKDIR)/text $(PAKDIR)/config $(PAKDIR)/scenario
#	@cp -p sound/* $(PAKDIR)/sound
#	@cp -p scenario/* $(PAKDIR)/scenario
	@cp -p text/*.tab $(PAKDIR)/text

$(DIRS64):
	@echo "===> PAK64 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK $(PAKDIR)/ $@/ > /dev/null

$(DIRS128):
	@echo "===> PAK128 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK128 $(PAKDIR)/ $@/ > /dev/null

$(DIRS192):
	@echo "===> PAK192 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK192 $(PAKDIR)/ $@/ > /dev/null

$(DIRS224):
	@echo "===> PAK224 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK224 $(PAKDIR)/ $@/ > /dev/null

$(OUTSIDE):
	@echo "===> OUTSIDE with REVISION and grounds"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) PAK128 $(PAKDIR)/ $@/ > /dev/null
	@echo -e -n "Obj=ground\nName=Outside\ncopyright=pak128.Britain 1.09 111.0 r" >$@/outsiderev.dat
	@svnversion >>$@/outsiderev.dat
	@echo -e "Image[0][0]=images/ls-water-128.0.0\n-" >>$@/outsiderev.dat
	@$(MAKEOBJ) PAK128 $(PAKDIR)/ $@/outsiderev.dat > /dev/null
	@rm $@/outsiderev.dat

clean:
	@echo "===> CLEAN"
	@rm -fr $(PAKDIR) $(DESTFILE).tbz2 $(DESTFILE).zip

# Note, this is a really sloppy way to do this.
# Also note, there are too many trains for a single zip file.
simutranslator:
	for x in $(TR_DIRS); do zip -r simutranslator/"$$x".zip "$$x"; done
	zip simutranslator/program_texts.zip simutranslator/*.dat
