final: prev: rec {
  postgresql_14_17 = prev.postgresql_14.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "14.17";

      withSystemdSupport = false;

      doCheck = false;
      doInstallCheck = false;

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-bODM1kA79/Dy7d0zPi7pugLt+pd8ZmYO2bSxBX52MKE=";
      };
    });

  postgresql_14_17-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_14_17.version;

    buildInputs = [ postgresql_14_17 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_14_17}/bin/psql $out/bin/
      cp ${postgresql_14_17}/bin/pg_dump $out/bin/
      cp ${postgresql_14_17}/bin/pg_dumpall $out/bin/
      cp ${postgresql_14_17}/bin/pg_restore $out/bin/
    '';
  };

  postgresql_15_12 = prev.postgresql_15.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "15.12";

      withSystemdSupport = false;

      doCheck = false;
      doInstallCheck = false;

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-O8hGKjjKCFcnDMiLlJo/Zlnw1cRMApxII1WDW2Gg9vc=";
      };
    });

  postgresql_15_12-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_15_12.version;

    buildInputs = [ postgresql_15_12 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_15_12}/bin/psql $out/bin/
      cp ${postgresql_15_12}/bin/pg_dump $out/bin/
      cp ${postgresql_15_12}/bin/pg_dumpall $out/bin/
      cp ${postgresql_15_12}/bin/pg_restore $out/bin/
    '';
  };

  postgresql_16_8 = prev.postgresql_16.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "16.8";

      withSystemdSupport = false;

      doCheck = false;
      doInstallCheck = false;

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-lGgIOlbODufSlGAbdNrT3Z/GnYev9h8Kn7Y8gT/379g=";
      };
    });

  postgresql_16_8-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_16_8.version;

    buildInputs = [ postgresql_16_8 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_16_8}/bin/psql $out/bin/
      cp ${postgresql_16_8}/bin/pg_dump $out/bin/
      cp ${postgresql_16_8}/bin/pg_dumpall $out/bin/
      cp ${postgresql_16_8}/bin/pg_restore $out/bin/
    '';
  };

  postgresql_17_4 = prev.postgresql_17.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      pname = "postgresql";
      version = "17.4";

      withSystemdSupport = false;
      doCheck = false;

      src = final.fetchurl {
        url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
        hash = "sha256-xGBbc/6hGWNAZpn5Sblm5dFzp+4Myu+JON7AyoqZX+c=";
      };
    });

  postgresql_17_4-client = final.stdenv.mkDerivation {
    pname = "postgresql-client";
    version = postgresql_17_4.version;

    buildInputs = [ postgresql_17_4 ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${postgresql_17_4}/bin/psql $out/bin/
      cp ${postgresql_17_4}/bin/pg_dump $out/bin/
      cp ${postgresql_17_4}/bin/pg_dumpall $out/bin/
      cp ${postgresql_17_4}/bin/pg_restore $out/bin/
    '';
  };
}
