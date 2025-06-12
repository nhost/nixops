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

        packages = rec {
          # we use this in the CI to prebuild the container build tools
          dummy-container = nix2containerPkgs.nix2container.buildImage {
            name = "dummy-container";
            tag = "latest";

            copyToRoot = pkgs.buildEnv {
              name = "image";
              paths = [
                pkgs.cacert
              ];
              pathsToLink = [
                "/bin"
                "/etc"
                "/lib"
                "/run"
                "/share"
                "/tmp"
                "/var"
              ];
            };
          };

          dummy-container-as-dir = pkgs.runCommand "image-as-dir" { } "${dummy-container.copyTo}/bin/copy-to dir:$out";
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
              postgresql_14_17-client
              postgresql_15_12-client
              postgresql_16_8-client
              postgresql_17_4-client
              postgresql_14_17
              postgresql_15_12
              postgresql_16_8
              postgresql_17_4
            ] ++ pkgs.lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
              self.packages.${system}.dummy-container
            ];
          };
        };

      });
}
