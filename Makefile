
default: test

test:
	@echo "== Test =="
	@if ! terraform fmt -write=false -check=true >> /dev/null; then \
		echo "✗ terraform fmt failed: $$d"; \
		exit 1; \
	else \
		echo "√ terraform fmt"; \
	fi


	@for d in $$(find . -type f -name '*.tf' -path "./examples/*" -not -path "**/.terraform/*" -exec dirname {} \; | sort -u); do \
		cd $$d; \
		terraform init -backend=false >> /dev/null; \
		terraform validate; \
		if [ $$? -eq 1 ]; then \
			echo "✗ terraform validate failed: $$d"; \
			exit 1; \
		fi; \
		cd $(CURDIR); \
	done
	@echo "√ terraform validate examples"; \

.PHONY: default test
