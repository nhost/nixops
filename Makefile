ifeq ($(shell uname -m),x86_64)
  ARCH?=x86_64
else ifeq ($(shell uname -m),arm64)
  ARCH?=aarch64
else ifeq ($(shell uname -m),aarch64)
  ARCH?=aarch64
else
  ARCH?=fixme-$(shell uname -m)
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
		.\#devShells.$(ARCH)-$(OS).ci


.PHONY: build-docker-image
build-docker-image:  ## Build postgres image
	cd lib/go/example && \
		nix flake update nixops && \
		nix develop -c make build-docker-image


.PHONY: build-dry-run
build-dry-run:  ## Run nix flake check
	@nix path-info \
		--derivation \
		.\#devShells.$(ARCH)-$(OS).ci
