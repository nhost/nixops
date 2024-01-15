{
  description = "Nhost's nix operations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

      lib = {
        go = import ./lib/go/go.nix;
        nix = import ./lib/nix/nix.nix;
      };
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
      });
}
