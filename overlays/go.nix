final: prev: rec {
  go = prev.go_1_23.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      version = "1.23.1";

      src = final.fetchurl {
        url = "https://go.dev/dl/go${version}.src.tar.gz";
        sha256 = "sha256-buROKYN50Ual5aprHFtdX10KM2XqvdcHQebiE0DsOw0=";
      };

    });

  buildGoModule = prev.buildGoModule.override { go = go; };

  golangci-lint = prev.golangci-lint.override {
    buildGo123Module = args: final.buildGoModule (args // rec {
      version = "1.61.0";
      src = prev.fetchFromGitHub {
        owner = "golangci";
        repo = "golangci-lint";
        rev = "v${version}";
        sha256 = "sha256-2YzVNOdasal27R92l6eVdeS81mAp0ZU6kYsC/Jfvkcg=";
      };

      vendorHash = "sha256-mFDCRxbLq08yRd0ko3CCPJD2BZiCB0Gwd1g+/1oR6w8=";

      ldflags = [
        "-s"
        "-w"
        "-X main.version=${version}"
        "-X main.commit=v${version}"
        "-X main.date=19700101-00:00:00"
      ];
    });
  };

  mockgen = prev.mockgen.override {
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

  golines = final.buildGoModule {
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
    version = "0.17.54";

    src = final.fetchFromGitHub {
      owner = "99designs";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-0aoEVvKsdWJd3+aC7NuC6gs81dRRByy2TVrV4l9MdWE=";
    };

    vendorHash = "sha256-wsuep7K5SlkTWCiOuzjrkODZgAsHDa9wO8nnwWQVYco=";

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
    version = "0.25.2";

    src = final.fetchFromGitHub {
      owner = "Yamashou";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-g+l493Nt0SuW4gwJh0s9Zeejpyx2oLxVDykIvBup638=";
    };

    vendorHash = "sha256-YGFMQrxghJIgmiwEPfEqaACH7OETVkD8O7oUhm9foJo=";

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
      version = "2.4.0";
      src = final.fetchFromGitHub {
        owner = "oapi-codegen";
        repo = "oapi-codegen";
        rev = "v${version}";
        sha256 = "sha256-Byb4bTtdn2Xi5hZXsAtcXA868VGQO6RORj1M2x8EAzg=";
      };

      subPackages = [ "cmd/oapi-codegen" ];
      vendorHash = "sha256-bp5sFZNJFQonwfF1RjCnOMKZQkofHuqG0bXdG5Hf3jU=";
    });
  };

}
