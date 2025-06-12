{ pkgs, nix2containerPkgs }:
{
  generic = import ./generic/generic.nix { inherit pkgs; };
  go = import ./go/go.nix { inherit pkgs nix2containerPkgs; };
  nix = import ./nix/nix.nix { inherit pkgs; };
}
