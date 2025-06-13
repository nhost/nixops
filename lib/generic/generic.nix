{ pkgs, nix2containerPkgs }:
let
  dockerImageFn =
    { name
    , tag
    , created
    , fromImage ? ""
    , copyToRoot ? null
    , maxLayers ? 100
    , config ? { }
    }:
    nix2containerPkgs.nix2container.buildImage {
      inherit name tag created copyToRoot fromImage maxLayers config;
    };
in
{
  docker-image =
    { name
    , tag
    , created
    , fromImage ? ""
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
