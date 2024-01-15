final: prev:
{
  nhost-cli = final.callPackage ./nhost-cli.nix { inherit final; };
} // import ./go.nix final prev
