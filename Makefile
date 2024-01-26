ifeq ($(shell uname -m),x86_64)
  ARCH?=x86_64
else ifeq ($(shell uname -m),arm64)
  ARCH?=aarch64
endif

ifeq ($(shell uname -o),Darwin)
  OS?=darwin
else
  OS?=linux
endif

ifeq ($(CI),true)
  build-options=--option system $(ARCH)-linux --extra-platforms ${ARCH}-linux
endif

.PHONY: build
build:  ## Build application and places the binary under ./result/bin
	nix build $(build-options) \
		--print-build-logs \
		.\#devShells.$(ARCH)-$(OS).default


.PHONY: build-dry-run
build-dry-run:  ## Run nix flake check
	nix build $(build-options) \
		--dry-run \
		--json \
		--print-build-logs \
		.\#devShells.$(ARCH)-$(OS).default
