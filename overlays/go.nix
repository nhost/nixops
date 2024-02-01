final: prev: rec {
  go = prev.go_1_21.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      version = "1.21.6";

      src = final.fetchurl {
        url = "https://go.dev/dl/go${version}.src.tar.gz";
        sha256 = "sha256-Ekkmpi5F942qu67bnAEdl2MxhqM8I4/8HiUyDAIEYkg=";
      };

    });

  buildGoNhostModule = prev.buildGoModule.override { go = go; };

  golangci-lint = prev.golangci-lint.override rec {
    buildGoModule = args: prev.buildGoModule.override { go = go; } (args // rec {
      version = "1.55.2";
      src = prev.fetchFromGitHub {
        owner = "golangci";
        repo = "golangci-lint";
        rev = "v${version}";
        sha256 = "sha256-DO71wfDmCuziEcsme1g1uNIl3MswA+EkQcYzOYHbG+I=";
      };

      vendorHash = "sha256-0+jImfMdVocOczGWeO03YXUg5yKYTu3WeJaokSlcYFM=";

      ldflags = [
        "-s"
        "-w"
        "-X main.version=${version}"
        "-X main.commit=v${version}"
        "-X main.date=19700101-00:00:00"
      ];
    });
  };

  mockgen = prev.mockgen.override rec {
    buildGoModule = args: final.buildGoModule (args // rec {
      version = "0.4.0";
      src = final.fetchFromGitHub {
        owner = "uber-go";
        repo = "mock";
        rev = "v${version}";
        sha256 = "sha256-3nt70xrZisK5vgQa+STZPiY4F9ITKw8PbBWcKoBn4Vc=";
      };
      vendorHash = "sha256-mcNVud2jzvlPPQEaar/eYZkP71V2Civz+R5v10+tewA=";
    });
  };

  golines = final.buildGoModule rec {
    name = "golines";
    version = "0.11.0";
    src = final.fetchFromGitHub {
      owner = "dbarrosop";
      repo = "golines";
      rev = "b7e767e781863a30bc5a74610a46cc29485fb9cb";
      sha256 = "sha256-pxFgPT6J0vxuWAWXZtuR06H9GoGuXTyg7ue+LFsRzOk=";
    };
    vendorHash = "sha256-rxYuzn4ezAxaeDhxd8qdOzt+CKYIh03A9zKNdzILq18=";

    meta = with final.lib; {
      description = "A golang formatter that fixes long lines";
      homepage = "https://github.com/segmentio/golines";
      maintainers = [ "nhost" ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

  govulncheck = final.buildGoModule rec {
    name = "govulncheck";
    version = "v1.0.1";
    src = final.fetchFromGitHub {
      owner = "golang";
      repo = "vuln";
      rev = "${version}";
      sha256 = "sha256-wAZJruDyAavfqS/+7yDaT4suE4eivCbL7g4tQoqUDlQ=";
    };
    vendorHash = "sha256-LqKDQPOXOF+A2G3e483jeV7ziUb87ePnk8VMkLAms74=";

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
    version = "0.17.42";

    src = final.fetchFromGitHub {
      owner = "99designs";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-Rqet3wLRtyts493yUdUHNgEKkfKR9YuHGINT8IRXSpk=";
    };

    vendorHash = "sha256-0Yo2oqKGHDbMuqqjwO/CN/pApSZcVcPF3T//k5ogHM0=";

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
    version = "0.16.2";

    src = final.fetchFromGitHub {
      owner = "Yamashou";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-XNmCSkgJJ2notrv0Din4jlU9EoHJcznjEUiXQgQ5a7I=";
    };

    vendorHash = "sha256-6iwNykvW1m+hl6FzMNbvvPpBNp8OQn2/vfJLmAj60Mw=";

    doCheck = false;

    subPackages = [ "./." ];

    meta = with final.lib; {
      description = "This is Go library for building GraphQL client with gqlgen";
      homepage = "https://github.com/Yamashou/gqlgenc";
      license = licenses.mit;
      maintainers = [ "@nhost" ];
    };
  };

  oapi-codegen = prev.oapi-codegen.override rec {
    buildGoModule = args: final.buildGoModule (args // rec {
      version = "2.0.0";
      src = final.fetchFromGitHub {
        owner = "deepmap";
        repo = "oapi-codegen";
        rev = "v${version}";
        sha256 = "sha256-LZaNuT2JMWYXllKxAOciKT9ybBFuCV1LyIP2MwxbJ2M=";
      };

      subPackages = [ "cmd/oapi-codegen" ];
      vendorHash = "sha256-d5PvdxQCAwMPi1Oh2E7p4dVRukED26N+3cU8FMcT16U=";
    });
  };

}
