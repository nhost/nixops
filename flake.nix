{
  description = "Nhost's nix operations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter, nix2container }:
    let
      nix-src = nix-filter.lib.filter {
        root = ./.;
        include = [
          (nix-filter.lib.matchExt "nix")
        ];
      };

      overlays = [
        (import ./overlays/default.nix)
      ];
    in
    {
      overlays.default = import ./overlays/default.nix;

      lib = import ./lib/lib.nix;
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        nix2containerPkgs = nix2container.packages.${system};

        nix-lib = import ./lib/nix/nix.nix { inherit pkgs; };
      in
      {
        checks = {
          nix-tests = nix-lib.check { src = nix-src; };
        };

        devShells = flake-utils.lib.flattenTree {
          default = pkgs.mkShell {
            buildInputs = with pkgs;[
              gh
              gnused
            ];
          };

          ci = pkgs.mkShell {
            buildInputs = with pkgs; [
              go
              golangci-lint
              mockgen
              golines
              govulncheck
              gqlgen
              gqlgenc
              oapi-codegen
              nhost-cli
              skopeo
              postgresql_14_18-client
              postgresql_15_13-client
              postgresql_16_9-client
              postgresql_17_5-client
              postgresql_14_18
              postgresql_15_13
              postgresql_16_9
              postgresql_17_5
            ];
          };
        };

      });
}
