final: prev: rec {
  go = prev.go_1_22.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      version = "1.23.1";

      src = final.fetchurl {
        url = "https://go.dev/dl/go${version}.src.tar.gz";
        sha256 = "sha256-buROKYN50Ual5aprHFtdX10KM2XqvdcHQebiE0DsOw0=";
      };

    });

  buildGoModule = prev.buildGoModule.override { go = go; };

  golangci-lint = prev.golangci-lint.override rec {
    buildGoModule = args: final.buildGoModule (args // rec {
      version = "1.60.3";
      src = prev.fetchFromGitHub {
        owner = "golangci";
        repo = "golangci-lint";
        rev = "v${version}";
        sha256 = "sha256-0ScdJ5td2N8WF1dwHQ3dBSjyr1kqgrzCfBzbRg9cRrw=";
      };

      vendorHash = "sha256-ixeswsfx36D0Tg103swbBD8UXXLNYbxSMYDE+JOm+uw=";

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
      rev = "77e7859691753d986722a03f28c048306390801b";
      sha256 = "sha256-6w8K6JGumUeZUFZS4+SIPh2OizTjSQgHYfsjZRr31lg=";
    };
    vendorHash = "sha256-jI3/m1UdZMKrS3H9jPhcVAUCjc1G/ejzHi9SCTy24ak=";

    meta = with final.lib; {
      description = "A golang formatter that fixes long lines";
      homepage = "https://github.com/segmentio/golines";
      maintainers = [ "nhost" ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

  govulncheck = final.buildGoModule rec {
    name = "govulncheck";
    version = "v1.1.3";
    src = final.fetchFromGitHub {
      owner = "golang";
      repo = "vuln";
      rev = "${version}";
      sha256 = "sha256-ydJ8AeoCnLls6dXxjI05+THEqPPdJqtAsKTriTIK9Uc=";
    };
    vendorHash = "sha256-jESQV4Na4Hooxxd0RL96GHkA7Exddco5izjnhfH6xTg=";

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
    version = "0.17.49";

    src = final.fetchFromGitHub {
      owner = "99designs";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-dHKK21xIc7C0Ei/4+WHrVaDMFikZxHP6hTA8zF9ZEZ8=";
    };

    vendorHash = "sha256-1NxgK/4ccUqf0m3rJkM0FXKK5wNJmCeCNnV2FyZVRoQ=";

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
    version = "0.24.0";

    src = final.fetchFromGitHub {
      owner = "Yamashou";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-tKEHqo7drOwHIRCgKEXbELi0u9uRpXSwB9R1fPhv/PE=";
    };

    vendorHash = "sha256-lQ2KQF+55qvscnYfm1jLK/4DdwFBaRZmv9oa/BUSoXI=";

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
      version = "2.3.0";
      src = final.fetchFromGitHub {
        owner = "oapi-codegen";
        repo = "oapi-codegen";
        rev = "v${version}";
        sha256 = "sha256-Gcl0i3K2ncrxMSLHCPWBleRGdVIVkUo7vcp+tDNpkOw=";
      };

      subPackages = [ "cmd/oapi-codegen" ];
      vendorHash = "sha256-urPMLEaisgndbHmS1sGQ07c+VRBdxIz0wseLoSLVWQo=";
    });
  };

}
