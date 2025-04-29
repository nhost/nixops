final: prev: rec {
  go = prev.go_1_24.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      version = "1.24.2";

      src = final.fetchurl {
        url = "https://go.dev/dl/go${version}.src.tar.gz";
        sha256 = "sha256-ncd/+twW2DehvzLZnGJMtN8GR87nsRnt2eexvMBfLgA=";
      };

    });

  buildGoModule = prev.buildGoModule.override { go = go; };

  golangci-lint = prev.golangci-lint.override {
    buildGo124Module = args: final.buildGo124Module (args // rec {
      version = "2.1.5";
      src = prev.fetchFromGitHub {
        owner = "golangci";
        repo = "golangci-lint";
        rev = "v${version}";
        sha256 = "sha256-wCBGtKlaKW6Btim9xe0K8IzdNVcBDEidhr6LCwLUx98=";
      };

      vendorHash = "sha256-Dd4GTjkq1LTH7G1Qj8y+q0LW/8cQECN8o+3xHFtmpwI=";

      ldflags = [
        "-s"
        "-w"
        "-X main.version=${version}"
        "-X main.commit=v${version}"
        "-X main.date=19700101-00:00:00"
      ];
    });
  };

  golines = final.buildGoModule {
    name = "golines";
    version = "0.13.0-beta";
    src = final.fetchFromGitHub {
      owner = "segmentio";
      repo = "golines";
      rev = "fc305205784a70b4cfc17397654f4c94e3153ce4";
      sha256 = "sha256-ZdCR4ZC1+Llyt/rcX0RGisM98u6rq9/ECUuHEMV+Kkc=";
    };
    vendorHash = "sha256-mmdaHm3YL/2eB/r3Sskd9liljKAe3/c8T0z5KIUHeK0=";

    meta = with final.lib; {
      description = "A golang formatter that fixes long lines";
      homepage = "https://github.com/segmentio/golines";
      maintainers = [ "nhost" ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

  govulncheck = final.buildGoModule rec {
    name = "govulncheck";
    version = "v1.1.4";
    src = final.fetchFromGitHub {
      owner = "golang";
      repo = "vuln";
      rev = "${version}";
      sha256 = "sha256-d1JWh/K+65p0TP5vAQbSyoatjN4L5nm3VEA+qBSrkAA=";
    };
    vendorHash = "sha256-MSTKDeWVxD2Fa6fNoku4EwFwC90XZ5acnM67crcgXDg=";

    doCheck = false;

    meta = with final.lib; {
      description = "the database client and tools for the Go vulnerability database";
      homepage = "https://github.com/golang/vuln";
      maintainers = [ "nhost" ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

  gqlgen = final.buildGoModule rec {
    pname = "gqlgen";
    version = "0.17.72";

    src = final.fetchFromGitHub {
      owner = "99designs";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-7jnUzU+6kHu9uU2dbxqV9FzDIrw1tTP03ecbQHcHoak=";
    };

    vendorHash = "sha256-Q9voEyziSlq9Ele4fz/obQS4ufapa4zK3cTd493XJgU=";

    doCheck = false;

    subPackages = [ "./." ];

    meta = with final.lib; {
      description = "go generate based graphql server library";
      homepage = "https://gqlgen.com";
      license = licenses.mit;
      maintainers = [ "@nhost" ];
    };
  };

  gqlgenc = final.buildGoModule rec {
    pname = "gqlgenc";
    version = "0.32.0";

    src = final.fetchFromGitHub {
      owner = "Yamashou";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-3Qz1o91IPKjhzIYzKcdl456AWn6nsrcQ04VglBlpe54=";
    };

    vendorHash = "sha256-Ax5MA4wqQdXSDEIkiG5TcvFIN6YtyXuiJOdQGPYIb+Y=";

    doCheck = false;

    subPackages = [ "./." ];

    meta = with final.lib; {
      description = "This is Go library for building GraphQL client with gqlgen";
      homepage = "https://github.com/Yamashou/gqlgenc";
      license = licenses.mit;
      maintainers = [ "@nhost" ];
    };
  };

  oapi-codegen = prev.oapi-codegen.override {
    buildGoModule = args: final.buildGoModule (args // rec {
      version = "2.4.1";
      src = final.fetchFromGitHub {
        owner = "oapi-codegen";
        repo = "oapi-codegen";
        rev = "v${version}";
        hash = "sha256-21VhHSyfF+NHkXlr2svjwBNZmfS1O448POBP9XUQxak=";
      };

      vendorHash = "sha256-bp5sFZNJFQonwfF1RjCnOMKZQkofHuqG0bXdG5Hf3jU=";
    });
  };

}
