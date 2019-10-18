DOCS_CMD=terraform-docs
DOCS_FLAGS=--sort-inputs-by-required --with-aggregate-type-defaults --indent=1

docs:
	which terraform-docs
	mkdir -p docs
	${DOCS_CMD} markdown table ./variables.tf ${DOCS_FLAGS} > docs/inputs.md
	${DOCS_CMD} markdown table ./outputs.tf ${DOCS_FLAGS} > docs/outputs.md
