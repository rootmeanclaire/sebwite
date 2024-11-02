OUTDIR=out
TEMPLATE_DIR=templates
GEN_HTML=$(addprefix $(OUTDIR)/, $(subst .yml,.html,$(wildcard *.yml)))

all: $(GEN_HTML)

.DELETE_ON_ERROR: $(GEN_HTML)

$(OUTDIR)/%.html: \
		$(OUTDIR) $(TEMPLATE_DIR)/base.html \
		$(TEMPLATE_DIR)/%.html %.yml
	./render-template.py $(notdir $(word 3,$^)) $(word 4,$^) > $@

$(OUTDIR):
	mkdir -p $(OUTDIR)
	ln -s $$(pwd)/dark.css $(OUTDIR)/style.css

clean:
	rm -rf $(OUTDIR)
