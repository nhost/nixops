final: prev: rec {
  postgresql_14_13 = prev.postgresql_14.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "14.13";

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-Wao8S0lasmqexp860KAijFHw/m+s82NN+tTRGX1hOlY=";
      };
    });

  postgresql_14_13-client = postgresql_14_13.overrideAttrs
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

      # postFixup = "";
      # outputs = [ "out" "lib" "dev" ];
    });

  postgresql_15_8 = prev.postgresql_15.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "15.8";

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-RANRX5pp7rPv68mPMLjGlhIr/fiV6Ss7I/W452nty2o=";
      };
    });

  postgresql_15_8-client = postgresql_15_8.overrideAttrs
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

      # postFixup = "";
      # outputs = [ "out" "lib" "dev" ];
    });

  postgresql_16_4 = prev.postgresql_16.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "16.4";

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-lxdm1kWqc+k7nvTjvkQgG09FtUdwlbBJElQD+fM4bW8=";
      };
    });

  postgresql_16_4-client = postgresql_16_4.overrideAttrs
    (finalAttrs: previousAttrs: {
      buildInputs = with final.pkgs; [ zlib openssl icu ];
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
          cp src/bin/pg_dump/pg_dumpall $out/bin
          cp src/bin/pg_dump/pg_restore $out/bin
          cp src/bin/psql/psql $out/bin
          moveToOutput "lib/pgxs" "$out" # looks strange, but not deleting it
          moveToOutput "lib/libpgcommon*.a" "$out"
          moveToOutput "lib/libpgport*.a" "$out"
          moveToOutput "lib/libecpg*" "$out"
        '';

      # postFixup = ""; # this may need fixing to add locales
      # outputs = [ "out" "lib" "dev" ];
    });
}
