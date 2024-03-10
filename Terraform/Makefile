SHELL = /usr/bin/

.PHONY: default
default:
	@echo "nothing to build"

.PHONY: wc
wc:
	find . -name '*.tf' -o -iname '*.tfvars' | xargs wc -l
