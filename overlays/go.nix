final: prev: rec {
  go = prev.go_1_23.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      version = "1.23.6";

      src = final.fetchurl {
        url = "https://go.dev/dl/go${version}.src.tar.gz";
        sha256 = "sha256-A5xbBOZSedrO7opvcecL0Fz1uAF4K293xuGeLtBREiI=";
      };

    });

  buildGoModule = prev.buildGoModule.override { go = go; };

  golangci-lint = prev.golangci-lint.override {
    buildGoModule = args: final.buildGoModule (args // rec {
      version = "1.63.4";
      src = prev.fetchFromGitHub {
        owner = "golangci";
        repo = "golangci-lint";
        rev = "v${version}";
        sha256 = "sha256-7nIo6Nuz8KLuQlT7btjnTRFpOl+KVd30v973HRKzh08=";
      };

      vendorHash = "sha256-atr4HMxoPEfGeaNlHqwTEAcvgbSyzgCe262VUg3J86c=";

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
    version = "0.17.63";

    src = final.fetchFromGitHub {
      owner = "99designs";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-J9+pleHdbQMHP/Aq9Pl6ise6PDvRqxQ72Iq7SNxgMws=";
    };

    vendorHash = "sha256-hPUWYOfCx+kW2dJsjkCE/7bwofnGdQbDTvfZ877/pCk=";

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
    version = "0.30.2";

    src = final.fetchFromGitHub {
      owner = "Yamashou";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-F6EuOqB9ccat9pytJn8glBn5X9eEsEUN2+8+FqVvEbY=";
    };

    vendorHash = "sha256-h3ePmfRkGqVXdtjX2cU5y2HnX+VkmTWNwrEkhLAmrlU=";

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
