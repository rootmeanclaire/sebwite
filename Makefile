INDIR=content
OUTDIR=out
TEMPLATE_DIR=templates

# All input YAML files
IN_YML=$(shell find . -name '*.yml')
# Input YAML files without directory prefix
BASE_YML=$(IN_YML:./$(INDIR)/%=%)
# HTML files to generate
GEN_HTML=$(addprefix $(OUTDIR)/, $(BASE_YML:%.yml=%.html))

all: $(OUTDIR) $(GEN_HTML)

.DELETE_ON_ERROR: $(GEN_HTML)

$(OUTDIR)/%.html: $(OUTDIR) \
		$(TEMPLATE_DIR)/base.html \
		$(TEMPLATE_DIR)/%.html \
		$(INDIR)/%.yml
	./render-template.py $(notdir $(word 3,$^)) $(word 4,$^) > $@

$(OUTDIR):
	mkdir -p $(dir $(GEN_HTML))
	ln -s $$(pwd)/dark.css $(OUTDIR)/style.css

clean:
	rm -rf $(OUTDIR)
