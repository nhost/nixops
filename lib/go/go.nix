{ pkgs }:
let
  goCheckDeps = with pkgs; [
    go
    clang
    golangci-lint
    richgo
    golines
    gofumpt
    govulncheck
  ];
in
{
  devShell =
    { buildInputs ? [ ]
    , shellHook ? ""
    }: pkgs.mkShell {
      inherit shellHook;

      buildInputs = with pkgs; [
        gnumake
        nixpkgs-fmt
      ] ++ goCheckDeps ++ buildInputs;
    };

  check =
    { src
    , submodule ? ""
    , ldflags
    , tags
    , buildInputs
    , nativeBuildInputs
    , checkDeps ? [ ]
    , preCheck ? ""
    , extraCheck ? ""
    , goTestFlags ? ""
    }: pkgs.runCommand "gotests"
      {
        nativeBuildInputs = goCheckDeps ++ checkDeps ++ buildInputs ++ nativeBuildInputs;
      }
      ''
        export GOLANGCI_LINT_CACHE=$TMPDIR/.cache/golangci-lint
        export GOCACHE=$TMPDIR/.cache/go-build
        export GOMODCACHE="$TMPDIR/.cache/mod"
        export GOPATH="$TMPDIR/.cache/gopath"

        ${preCheck}

        echo "➜ Source: ${src}"

        echo "➜ Running go generate ./${submodule}/... and checking sha1sum of all files"
        mkdir -p $TMPDIR/generate
        cd $TMPDIR/generate
        cp -r ${src}/* .
        chmod +w -R .

        go generate ./${submodule}/...
        find . -type f ! -path "./vendor/*" -print0 | xargs -0 sha1sum > $TMPDIR/sum
        cd ${src}
        sha1sum -c $TMPDIR/sum || (echo "❌ ERROR: go generate changed files" && exit 1)

        echo "➜ Running code formatters, if there are changes, fail"
        golines -l --base-formatter=gofumpt . | diff - /dev/null

        echo "➜ Checking for vulnerabilities"
        govulncheck -scan=package ./...

        echo "➜ Running golangci-lint"
        golangci-lint run \
          --timeout 600s \
          ./${submodule}/...

        echo "➜ Running tests"
        richgo test \
          -tags="${pkgs.lib.strings.concatStringsSep " " tags}" \
          -ldflags="${pkgs.lib.strings.concatStringsSep " " ldflags}" \
          -v ${goTestFlags} ./${submodule}/...

        ${extraCheck}

        mkdir $out
      '';

  package =
    { name
    , submodule ? ""
    , description ? ""
    , src
    , version
    , ldflags
    , buildInputs
    , nativeBuildInputs
    , postInstall ? ""
    }: (pkgs.buildGoModule {
      inherit src version ldflags buildInputs nativeBuildInputs;

      pname = name;

      vendorHash = null;

      doCheck = false;

      subPackages = [ submodule ];

      postInstall = postInstall;

      meta = with pkgs.lib; {
        description = description;
        homepage = "https://github.com/nhost/be";
        maintainers = [ "nhost" ];
        platforms = platforms.linux ++ platforms.darwin;
      };
    }).overrideAttrs (old: old // {

      buildPhase = old.buildPhase + ''
        dir=$NIX_BUILD_TOP/go/bin/"$GOOS"_"$GOARCH"
        if [ -d $dir ]; then
          mv $dir/* $dir/..
          rm -rf $dir
        fi
      '';
    });

  docker-image =
    { name
    , version
    , package
    , buildInputs
    , contents ? [ ]
    , config ? { }
    }:
    pkgs.dockerTools.buildLayeredImage {
      inherit name;
      tag = version;
      created = "now";

      contents = with pkgs; [
        cacert
        package
        (writeTextFile {
          name = "tmp-file";
          text = ''
            dummy file to generate tmpdir
          '';
          destination = "/tmp/tmp-file";
        })
        # busybox
      ] ++ buildInputs ++ contents;
      config = {
        Env = [
          "TMPDIR=/tmp"
        ];
        Entrypoint = [
          "${package}/bin/${name}"
        ];
      } // config;
    };

}

