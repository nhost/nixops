{ pkgs, nix2containerPkgs }:
let
  dockerImageFn =
    { name
    , tag
    , created
    , fromImage ? null
    , copyToRoot ? null
    , config ? { }
    }:
    nix2containerPkgs.nix2container.buildImage {
      inherit name tag created copyToRoot config;
    };
in
{
  docker-image =
    { name
    , tag
    , created
    , fromImage ? null
    , copyToRoot ? null
    , config ? { }
    }:
    pkgs.runCommand "image-as-dir" { } ''
      ${(dockerImageFn {
        inherit name tag created fromImage copyToRoot config;
      }).copyTo}/bin/copy-to dir:$out
    '';
}
