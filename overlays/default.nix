final: prev:
{

  openssl_patched = prev.callPackage ./openssl/default.nix {
    inherit (final) lib stdenv;
    inherit (final) fetchurl buildPackages perl coreutils;
    inherit (final) writeShellScript makeBinaryWrapper removeReferencesTo testers;
  };

  nhost-cli = final.callPackage ./nhost-cli.nix { inherit final; };
} // import ./go.nix final prev
  // import ./postgres.nix final prev
