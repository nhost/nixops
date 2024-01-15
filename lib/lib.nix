{ pkgs }:
{
  go = import ./go/go.nix { inherit pkgs; };
  nix = import ./nix/nix.nix { inherit pkgs; };
}
