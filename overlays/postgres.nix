final: prev: rec {
  postgresql_146 = prev.postgresql_14.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "14.6";

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-UIhA/BgJ05q3InTV8Tfau5/X+0+TPaQWiu67IAae3yI=";
      };
    });

  postgresql_146-client = postgresql_146.overrideAttrs
    (finalAttrs: previousAttrs: {
      buildInputs = with final.pkgs; [ zlib openssl ];
      configureFlags = [
        "--with-openssl"
        "--without-readline"
        "--sysconfdir=/etc"
        "--libdir=$(lib)/lib"
        "--with-system-tzdata=${final.pkgs.tzdata}/share/zoneinfo"
      ];

      separateDebugInfo = false;
      buildFlags = [ ];
      installTargets = [ "-C src/bin install" "-C ../interfaces install" ];

      postInstall =
        ''
          cp src/bin/pg_dump/pg_dump $out/bin
          cp src/bin/pg_dump/pg_restore $out/bin
          cp src/bin/psql/psql $out/bin
          moveToOutput "lib/pgxs" "$out" # looks strange, but not deleting it
          moveToOutput "lib/libpgcommon*.a" "$out"
          moveToOutput "lib/libpgport*.a" "$out"
          moveToOutput "lib/libecpg*" "$out"
        '';

      postFixup = "";
      outputs = [ "out" "lib" ];
    });
}

