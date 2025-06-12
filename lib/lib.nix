{ pkgs, nix2containerPkgs }:
{
  go = import ./go/go.nix { inherit pkgs nix2containerPkgs; };
  nix = import ./nix/nix.nix { inherit pkgs; };
}
