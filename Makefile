# Resume build. `make` builds all variants into build/.
# Requires: pdflatex (TeX Live / MacTeX)

NAME     := Aashish-Singhal
VARIANTS := ai-platform backend-infra fullstack
BUILD    := build
PDFS     := $(addprefix $(BUILD)/$(NAME)-,$(addsuffix .pdf,$(VARIANTS)))
SOURCES  := $(wildcard core/*.tex)

.PHONY: all clean pages open
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

# Report page counts; warns if a variant spills past one page.
pages:
	@echo "==> page counts"
	@mkdir -p $(BUILD)
	@for v in $(VARIANTS); do \
		n=$$(pdflatex -interaction=nonstopmode -jobname=pgchk -output-directory=$(BUILD) \
			variants/$$v.tex 2>&1 | grep -oE '\([0-9]+ pages?' | grep -oE '[0-9]+'); \
		printf "    %-16s %s page(s)" "$$v" "$$n"; \
		if [ "$$n" = "1" ]; then echo ""; else echo "   <-- over one page"; fi; \
	done; \
	rm -f $(BUILD)/pgchk.*

open: all
	@open $(BUILD)/$(NAME)-ai-platform.pdf

clean:
	@rm -rf $(BUILD)
	@echo "cleaned"
