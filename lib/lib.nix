{ pkgs, nix2containerPkgs }:
let
  dockerImageFn =
    { ... }@args:
    nix2containerPkgs.nix2container.buildImage {
      inherit args;
    };
in
{
  go = import ./go/go.nix { inherit pkgs nix2containerPkgs; };
  nix = import ./nix/nix.nix { inherit pkgs; };

  docker-image =
    { ... }@args:
    pkgs.runCommand "image-as-dir" { } ''
      ${(dockerImageFn {
        inherit args;
      }).copyTo}/bin/copy-to dir:$out
    '';
}
