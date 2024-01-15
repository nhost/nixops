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

        nixops-go = nixops.lib.go { inherit pkgs; };

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
          go-checks = nixops-go.check {
            inherit src ldflags tags buildInputs nativeBuildInputs checkDeps;
          };
        };

        devShells = flake-utils.lib.flattenTree rec {
          default = nixops-go.devShell {
            buildInputs = with pkgs; [
            ];
          };
        };

        packages = flake-utils.lib.flattenTree rec {
          example = nixops-go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
          };

          docker-image = nixops-go.docker-image {
            inherit name version buildInputs;

            package = example;
          };

          default = example;
        };

      }
    );
}

