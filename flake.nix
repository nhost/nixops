{
  description = "Nhost's nix operations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=9e2f27689a02e0ec978b92c1c4f775a41108c28d";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
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

        nix-lib = import ./lib/nix/nix.nix { inherit pkgs; };
      in
      {
        checks = {
          nix-tests = nix-lib.check { src = nix-src; };
        };

        devShells = flake-utils.lib.flattenTree {
          default = pkgs.mkShell {
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
              postgresql_14_15-client
              postgresql_15_10-client
              postgresql_16_6-client
              postgresql_17_2-client
              postgresql_14_15
              postgresql_15_10
              postgresql_16_6
              postgresql_17_2
            ];
          };
        };

      });
}
