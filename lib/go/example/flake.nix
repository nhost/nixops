{
  inputs = {
    nixops.url = "./../../../";
    nixpkgs.follows = "nixops/nixpkgs";
    flake-utils.follows = "nixops/flake-utils";
    nix-filter.follows = "nixops/nix-filter";
  };

  outputs = { self, nixops, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ nixops.overlays.default ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        nixops-lib = nixops.lib { inherit pkgs; };

        src = nix-filter.lib.filter {
          root = ./.;
          include = with nix-filter.lib;[
            (nix-filter.lib.matchExt "go")
            ./go.mod
          ];
        };

        name = "go-nixops-example";
        description = "nixops example for go";
        version = nixpkgs.lib.fileContents ./VERSION;
        module = "github.com/nhost/nixops/lib/go/example";
        tags = [ "integration" ];
        ldflags = [
          "-X main.Version=${version}"
        ];
        buildInputs = with pkgs; [ ];
        nativeBuildInputs = with pkgs; [ ];
        checkDeps = with pkgs; [ ];
      in
      {
        checks = {
          go-checks = nixops-lib.go.check {
            inherit src ldflags tags buildInputs nativeBuildInputs checkDeps;
          };
        };

        devShells = flake-utils.lib.flattenTree rec {
          default = nixops-lib.go.devShell {
            buildInputs = with pkgs; [
              mockgen
              gqlgen
              gqlgenc
              oapi-codegen
            ];
          };
        };

        packages = flake-utils.lib.flattenTree rec {
          example = nixops-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
          };

          example-arm64-darwin = (nixops-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
            cgoEnabled = 0;
          }).overrideAttrs (old: old // { GOOS = "darwin"; GOARCH = "arm64"; });

          example-amd64-darwin = (nixops-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
            cgoEnabled = 0;
          }).overrideAttrs (old: old // { GOOS = "darwin"; GOARCH = "amd64"; });

          example-arm64-linux = (nixops-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
            cgoEnabled = 0;
          }).overrideAttrs (old: old // { GOOS = "linux"; GOARCH = "arm64"; });

          example-amd64-linux = (nixops-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
            cgoEnabled = 0;
          }).overrideAttrs (old: old // { GOOS = "linux"; GOARCH = "amd64"; });

          docker-image = nixops-lib.go.docker-image {
            inherit name version buildInputs;

            package = example;
          };

          default = example;
        };

      }
    );
}

