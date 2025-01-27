final: prev: rec {
  postgresql_14_15 = prev.postgresql_14.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "14.15";

      doCheck = false;
      doInstallCheck = false;

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-AuiR4xS06e4ky9eAKNq3xz+cG6PjCDW8vvcf4iBAH8U=";
      };
    });

  postgresql_14_15-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_14_15.version;

    buildInputs = [ postgresql_14_15 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_14_15}/bin/psql $out/bin/
      cp ${postgresql_14_15}/bin/pg_dump $out/bin/
      cp ${postgresql_14_15}/bin/pg_dumpall $out/bin/
      cp ${postgresql_14_15}/bin/pg_restore $out/bin/
    '';
  };

  postgresql_15_10 = prev.postgresql_15.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "15.10";

      doCheck = false;
      doInstallCheck = false;

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-VavnONRB8OWGWLPsb4gJenE7XjtzE59iMNe1xMOJ5XM=";
      };
    });

  postgresql_15_10-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_15_10.version;

    buildInputs = [ postgresql_15_10 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_15_10}/bin/psql $out/bin/
      cp ${postgresql_15_10}/bin/pg_dump $out/bin/
      cp ${postgresql_15_10}/bin/pg_dumpall $out/bin/
      cp ${postgresql_15_10}/bin/pg_restore $out/bin/
    '';
  };

  postgresql_16_6 = prev.postgresql_16.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "16.6";

      doCheck = false;
      doInstallCheck = false;

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-Izac2szUUnCsXcww+p2iBdW+M/pQXh8XoEGNLK7KR3s=";
      };
    });

  postgresql_16_6-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_16_6.version;

    buildInputs = [ postgresql_16_6 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_16_6}/bin/psql $out/bin/
      cp ${postgresql_16_6}/bin/pg_dump $out/bin/
      cp ${postgresql_16_6}/bin/pg_dumpall $out/bin/
      cp ${postgresql_16_6}/bin/pg_restore $out/bin/
    '';
  };

  postgresql_17_2 = prev.postgresql_17.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "17.2";

      doCheck = false;

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-gu8nwK83UWldf2Ti2WNYMAX7tqDD32PQ5LQiEdcCEWQ=";
      };
    });

  postgresql_17_2-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_17_2.version;

    buildInputs = [ postgresql_17_2 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_17_2}/bin/psql $out/bin/
      cp ${postgresql_17_2}/bin/pg_dump $out/bin/
      cp ${postgresql_17_2}/bin/pg_dumpall $out/bin/
      cp ${postgresql_17_2}/bin/pg_restore $out/bin/
    '';
  };
}
