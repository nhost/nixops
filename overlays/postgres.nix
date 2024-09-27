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

  postgresql_14_13-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_14_13.version;

    buildInputs = [ postgresql_14_13 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_14_13}/bin/psql $out/bin/
      cp ${postgresql_14_13}/bin/pg_dump $out/bin/
      cp ${postgresql_14_13}/bin/pg_dumpall $out/bin/
      cp ${postgresql_14_13}/bin/pg_restore $out/bin/
    '';
  };

  postgresql_15_8 = prev.postgresql_15.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "15.8";

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-RANRX5pp7rPv68mPMLjGlhIr/fiV6Ss7I/W452nty2o=";
      };
    });

  postgresql_15_8-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_15_8.version;

    buildInputs = [ postgresql_15_8 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_15_8}/bin/psql $out/bin/
      cp ${postgresql_15_8}/bin/pg_dump $out/bin/
      cp ${postgresql_15_8}/bin/pg_dumpall $out/bin/
      cp ${postgresql_15_8}/bin/pg_restore $out/bin/
    '';
  };

  postgresql_16_4 = prev.postgresql_16.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "16.4";

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-lxdm1kWqc+k7nvTjvkQgG09FtUdwlbBJElQD+fM4bW8=";
      };
    });

  postgresql_16_4-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_16_4.version;

    buildInputs = [ postgresql_16_4 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_16_4}/bin/psql $out/bin/
      cp ${postgresql_16_4}/bin/pg_dump $out/bin/
      cp ${postgresql_16_4}/bin/pg_dumpall $out/bin/
      cp ${postgresql_16_4}/bin/pg_restore $out/bin/
    '';
  };
}
