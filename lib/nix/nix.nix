{ pkgs }:
let
  goCheckDeps = with pkgs; [
    go
    clang
    golangci-lint
    richgo
    golines
    gofumpt
    govulncheck
  ];
in
{
  check =
    { src
    }:
    pkgs.runCommand "check-nixpkgs-fmt"
      {
        nativeBuildInputs = with pkgs;
          [
            nixpkgs-fmt
          ];
      }
      ''
        mkdir $out
        nixpkgs-fmt --check ${src}
      '';
}
