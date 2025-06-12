{ pkgs, nix2containerPkgs }:
let
  dockerImageFn =
    { name
    , tag
    , created
    , fromImage ? null
    , copyToRoot ? null
    , maxLayers
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
    , maxLayers ? 100
    , config ? { }
    }:
    pkgs.runCommand "image-as-dir" { } ''
      ${(dockerImageFn {
        inherit name tag created fromImage copyToRoot maxLayers config;
      }).copyTo}/bin/copy-to dir:$out
    '';
}
