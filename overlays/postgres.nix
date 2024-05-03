final: prev: rec {
  postgresql_14_11 = prev.postgresql_14.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "14.11";

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-pnC9fc4i3K1Cl7JhE2s7HUoJpvVBcZViqhTKY78paKg=";
      };
    });

  postgresql_14_11-client = postgresql_14_11.overrideAttrs
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

  postgresql_15_6 = prev.postgresql_15.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "15.6";

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-hFUUbtnGnJOlfelUrq0DAsr60DXCskIXXWqh4X68svs=";
      };
    });

  postgresql_15_6-client = postgresql_15_6.overrideAttrs
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

  postgresql_16_2 = prev.postgresql_16.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "16.2";

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-RG6IKU28LJCFq0twYaZG+mBLS+wDUh1epnHC5a2bKVI=";
      };
    });

  postgresql_16_2-client = postgresql_16_2.overrideAttrs
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
