INDIR=content
OUTDIR=out
TEMPLATE_DIR=templates
BASE_TEMPLATE=$(TEMPLATE_DIR)/base.html

# All input YAML files
IN_YML=$(shell find $(INDIR) -name '*.yml')
# All input template files excluding the base
IN_TEMPLATES=$(filter-out $(BASE_TEMPLATE),$(shell find $(TEMPLATE_DIR) -name '*.html'))
# Input files without directory prefix
RAW_YML=$(IN_YML:$(INDIR)/%=%)
RAW_TEMPLATES=$(IN_TEMPLATES:$(TEMPLATE_DIR)/%=%)
# HTML files to generate
# Constructed from list of all templates and YAML files
GEN_HTML=$(addprefix $(OUTDIR)/, $(sort $(RAW_TEMPLATES) $(RAW_YML:%.yml=%.html)))

.PHONY: all
all: $(OUTDIR) $(GEN_HTML)

# Generate output by copying instead of symlinking
# GitHub Pages doesn't like symlinks
.PHONY: pages
pages: all
	rm $(OUTDIR)/style.css
	cp $$(pwd)/dark.css $(OUTDIR)/style.css
	cp $$(pwd)/base.css $(OUTDIR)

.DELETE_ON_ERROR: $(GEN_HTML)

# Each HTML file in OUTDIR depends on
# 1. OUTDIR existing
# 2. The base template file
# 3. That specific page's template file
# 4. That page's content file, if it exists
$(OUTDIR)/%.html: $(OUTDIR) \
		$(BASE_TEMPLATE) \
		$(TEMPLATE_DIR)/%.html \
		$(INDIR)/%.yml
	./render-template.py $(notdir $(word 3,$^)) $(word 4,$^) > $@
$(OUTDIR)/%.html: $(OUTDIR) \
		$(BASE_TEMPLATE) \
		$(TEMPLATE_DIR)/%.html
	./render-template.py $(notdir $(word 3,$^)) > $@

$(OUTDIR):
	mkdir -p $(dir $(GEN_HTML))
	ln -s $$(pwd)/dark.css $(OUTDIR)/style.css

clean:
	rm -rf $(OUTDIR)
