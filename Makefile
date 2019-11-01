.PHONY: docs
docs:
	.scripts/doc-gen.sh

.PHONY:push-docs
push-docs:
	.scripts/push-docs.sh