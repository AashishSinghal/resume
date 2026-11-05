# Resume build. `make` builds all variants into build/.
# Requires: pdflatex (TeX Live / MacTeX)

NAME     := Aashish-Singhal
# Every file in variants/ is a variant: add variants/<name>.tex and it is built and released automatically.
VARIANTS := $(sort $(basename $(notdir $(wildcard variants/*.tex))))
BUILD    := build
PDFS     := $(addprefix $(BUILD)/$(NAME)-,$(addsuffix .pdf,$(VARIANTS)))
SOURCES  := $(wildcard core/*.tex)

.PHONY: all clean pages check release open list
all: $(PDFS)

$(BUILD)/$(NAME)-%.pdf: variants/%.tex $(SOURCES)
	@mkdir -p $(BUILD)
	@echo "==> building $*"
	@pdflatex -interaction=nonstopmode -halt-on-error \
		-jobname=$(NAME)-$* -output-directory=$(BUILD) $< > /dev/null \
		|| (echo "FAILED: $* — rerun without >/dev/null to see the log"; exit 1)
	@pdflatex -interaction=nonstopmode -halt-on-error \
		-jobname=$(NAME)-$* -output-directory=$(BUILD) $< > /dev/null
	@rm -f $(BUILD)/*.aux $(BUILD)/*.log $(BUILD)/*.out
	@echo "    $@"

# Report page counts, and fail if any variant spills past two pages. CI runs this, so a
# change made from a phone still gets the one-page rule enforced.
pages:
	@echo "==> page counts"
	@mkdir -p $(BUILD)
	@fail=0; \
	for v in $(VARIANTS); do \
		n=$$(pdflatex -interaction=nonstopmode -jobname=pgchk -output-directory=$(BUILD) \
			variants/$$v.tex 2>&1 | grep -oE '\([0-9]+ pages?' | grep -oE '[0-9]+'); \
		printf "    %-16s %s page(s)" "$$v" "$$n"; \
		if [ "$$n" -le 2 ]; then echo ""; else echo "   <-- over two pages"; fail=1; fi; \
	done; \
	rm -f $(BUILD)/pgchk.*; \
	if [ $$fail -ne 0 ]; then echo "one or more variants exceed two pages"; exit 1; fi

# What CI runs: everything builds, and everything fits.
check: all pages

# Cut a versioned release:  make release VERSION=v1.2
release:
	@test -n "$(VERSION)" || (echo "usage: make release VERSION=v1.2"; exit 1)
	@git diff --quiet || (echo "working tree is dirty; commit first"; exit 1)
	git tag -a $(VERSION) -m "Resume $(VERSION)"
	git push origin $(VERSION)
	@echo "tagged $(VERSION) — Actions will build and attach the PDFs"

# Markdown list of variants (from each file's '% VARIANT:' header); used for release notes.
list:
	@sh scripts/list-variants.sh

open: all
	@open $(BUILD)/$(NAME)-ai-platform.pdf

clean:
	@rm -rf $(BUILD)
	@echo "cleaned"
