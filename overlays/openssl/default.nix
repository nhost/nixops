{ lib
, stdenv
, fetchurl
, buildPackages
, perl
, coreutils
, writeShellScript
, makeBinaryWrapper
, withCryptodev ? false
, cryptodev
, withZlib ? false
, zlib
, enableSSL2 ? false
, enableSSL3 ? false
, enableMD2 ? false
, enableKTLS ? stdenv.hostPlatform.isLinux
, static ? stdenv.hostPlatform.isStatic
, # path to openssl.cnf file. will be placed in $etc/etc/ssl/openssl.cnf to replace the default
  conf ? null
, removeReferencesTo
, testers
,
}:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Nixpkgs as
# files.

let
  common =
    { version
    , hash
    , patches ? [ ]
    , withDocs ? false
    , extraMeta ? { }
    ,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "openssl";
      inherit version;

      src = fetchurl {
        url =
          if lib.versionOlder version "3.0" then
            let
              versionFixed = builtins.replaceStrings [ "." ] [ "_" ] version;
            in
            "https://github.com/openssl/openssl/releases/download/OpenSSL_${versionFixed}/openssl-${version}.tar.gz"
          else
            "https://github.com/openssl/openssl/releases/download/openssl-${version}/openssl-${version}.tar.gz";
        inherit hash;
      };

      inherit patches;

      postPatch =
        ''
          patchShebangs Configure
        ''
        + lib.optionalString (lib.versionOlder version "1.1.1") ''
          patchShebangs test/*
          for a in test/t* ; do
            substituteInPlace "$a" \
              --replace /bin/rm rm
          done
        ''
        # config is a configure script which is not installed.
        + lib.optionalString (lib.versionAtLeast version "1.1.1") ''
          substituteInPlace config --replace '/usr/bin/env' '${buildPackages.coreutils}/bin/env'
        ''
        + lib.optionalString (lib.versionAtLeast version "1.1.1" && stdenv.hostPlatform.isMusl) ''
          substituteInPlace crypto/async/arch/async_posix.h \
            --replace '!defined(__ANDROID__) && !defined(__OpenBSD__)' \
                      '!defined(__ANDROID__) && !defined(__OpenBSD__) && 0'
        ''
        # Move ENGINESDIR into OPENSSLDIR for static builds, in order to move
        # it to the separate etc output.
        + lib.optionalString static ''
          substituteInPlace Configurations/unix-Makefile.tmpl \
            --replace 'ENGINESDIR=$(libdir)/engines-{- $sover_dirname -}' \
                      'ENGINESDIR=$(OPENSSLDIR)/engines-{- $sover_dirname -}'
        '';

      outputs =
        [
          "bin"
          "dev"
          "out"
          "man"
        ]
        ++ lib.optional withDocs "doc"
        # Separate output for the runtime dependencies of the static build.
        # Specifically, move OPENSSLDIR into this output, as its path will be
        # compiled into 'libcrypto.a'. This makes it a runtime dependency of
        # any package that statically links openssl, so we want to keep that
        # output minimal.
        ++ lib.optional static "etc";
      setOutputFlags = false;
      separateDebugInfo =
        !stdenv.hostPlatform.isDarwin && !(stdenv.hostPlatform.useLLVM or false) && stdenv.cc.isGNU;

      nativeBuildInputs =
        lib.optional (!stdenv.hostPlatform.isWindows) makeBinaryWrapper
        ++ [ perl ]
        ++ lib.optionals static [ removeReferencesTo ];
      buildInputs = lib.optional withCryptodev cryptodev ++ lib.optional withZlib zlib;

      # TODO(@Ericson2314): Improve with mass rebuild
      configurePlatforms = [ ];
      configureScript =
        {
          armv5tel-linux = "./Configure linux-armv4 -march=armv5te";
          armv6l-linux = "./Configure linux-armv4 -march=armv6";
          armv7l-linux = "./Configure linux-armv4 -march=armv7-a";
          x86_64-darwin = "./Configure darwin64-x86_64-cc";
          aarch64-darwin = "./Configure darwin64-arm64-cc";
          x86_64-linux = "./Configure linux-x86_64";
          x86_64-solaris = "./Configure solaris64-x86_64-gcc";
          powerpc64-linux = "./Configure linux-ppc64";
          riscv32-linux = "./Configure ${
            if lib.versionAtLeast version "3.2" then "linux32-riscv32" else "linux-latomic"
          }";
          riscv64-linux = "./Configure linux64-riscv64";
        }.${stdenv.hostPlatform.system} or (
          if stdenv.hostPlatform == stdenv.buildPlatform then
            "./config"
          else if stdenv.hostPlatform.isBSD then
            if stdenv.hostPlatform.isx86_64 then
              "./Configure BSD-x86_64"
            else if stdenv.hostPlatform.isx86_32 then
              "./Configure BSD-x86" + lib.optionalString stdenv.hostPlatform.isElf "-elf"
            else
              "./Configure BSD-generic${toString stdenv.hostPlatform.parsed.cpu.bits}"
          else if stdenv.hostPlatform.isMinGW then
            "./Configure mingw${
              lib.optionalString (stdenv.hostPlatform.parsed.cpu.bits != 32) (
                toString stdenv.hostPlatform.parsed.cpu.bits
              )
            }"
          else if stdenv.hostPlatform.isLinux then
            if stdenv.hostPlatform.isx86_64 then
              "./Configure linux-x86_64"
            else if stdenv.hostPlatform.isMicroBlaze then
              "./Configure linux-latomic"
            else if stdenv.hostPlatform.isMips32 then
              "./Configure linux-mips32"
            else if stdenv.hostPlatform.isMips64n32 then
              "./Configure linux-mips64"
            else if stdenv.hostPlatform.isMips64n64 then
              "./Configure linux64-mips64"
            else
              "./Configure linux-generic${toString stdenv.hostPlatform.parsed.cpu.bits}"
          else if stdenv.hostPlatform.isiOS then
            "./Configure ios${toString stdenv.hostPlatform.parsed.cpu.bits}-cross"
          else
            throw "Not sure what configuration to use for ${stdenv.hostPlatform.config}"
        );

      # OpenSSL doesn't like the `--enable-static` / `--disable-shared` flags.
      dontAddStaticConfigureFlags = true;
      configureFlags =
        [
          "shared" # "shared" builds both shared and static libraries
          "--libdir=lib"
          (
            if !static then
              "--openssldir=etc/ssl"
            else
            # Move OPENSSLDIR to the 'etc' output for static builds. Prepend '/.'
            # to the path to make it appear absolute before variable expansion,
            # else the 'prefix' would be prepended to it.
              "--openssldir=/.$(etc)/etc/ssl"
          )
        ]
        ++ lib.optionals withCryptodev [
          "-DHAVE_CRYPTODEV"
          "-DUSE_CRYPTODEV_DIGESTS"
        ]
        ++ lib.optional enableMD2 "enable-md2"
        ++ lib.optional enableSSL2 "enable-ssl2"
        ++ lib.optional enableSSL3 "enable-ssl3"
        # We select KTLS here instead of the configure-time detection (which we patch out).
        # KTLS should work on FreeBSD 13+ as well, so we could enable it if someone tests it.
        ++ lib.optional (lib.versionAtLeast version "3.0.0" && enableKTLS) "enable-ktls"
        ++ lib.optional (lib.versionAtLeast version "1.1.1" && stdenv.hostPlatform.isAarch64) "no-afalgeng"
        # OpenSSL needs a specific `no-shared` configure flag.
        # See https://wiki.openssl.org/index.php/Compilation_and_Installation#Configure_Options
        # for a comprehensive list of configuration options.
        ++ lib.optional (lib.versionAtLeast version "1.1.1" && static) "no-shared"
        ++ lib.optional (lib.versionAtLeast version "3.0.0" && static) "no-module"
        # This introduces a reference to the CTLOG_FILE which is undesired when
        # trying to build binaries statically.
        ++ lib.optional static "no-ct"
        ++ lib.optional withZlib "zlib"
        # /dev/crypto support has been dropped in OpenBSD 5.7.
        #
        # OpenBSD's ports does this too,
        # https://github.com/openbsd/ports/blob/a1147500c76970fea22947648fb92a093a529d7c/security/openssl/3.3/Makefile#L25.
        #
        # https://github.com/openssl/openssl/pull/10565 indicated the
        # intent was that this would be configured properly automatically,
        # but that doesn't appear to be the case.
        ++ lib.optional stdenv.hostPlatform.isOpenBSD "no-devcryptoeng"
        ++ lib.optionals (stdenv.hostPlatform.isMips && stdenv.hostPlatform ? gcc.arch) [
          # This is necessary in order to avoid openssl adding -march
          # flags which ultimately conflict with those added by
          # cc-wrapper.  Openssl assumes that it can scan CFLAGS to
          # detect any -march flags, using this perl code:
          #
          #   && !grep { $_ =~ /-m(ips|arch=)/ } (@{$config{CFLAGS}})
          #
          # The following bogus CFLAGS environment variable triggers the
          # the code above, inhibiting `./Configure` from adding the
          # conflicting flags.
          "CFLAGS=-march=${stdenv.hostPlatform.gcc.arch}"
        ];

      makeFlags = [
        "MANDIR=$(man)/share/man"
        # This avoids conflicts between man pages of openssl subcommands (for
        # example 'ts' and 'err') man pages and their equivalent top-level
        # command in other packages (respectively man-pages and moreutils).
        # This is done in ubuntu and archlinux, and possiibly many other distros.
        "MANSUFFIX=ssl"
      ];

      enableParallelBuilding = true;

      postInstall =
        (
          if static then
            ''
              # OPENSSLDIR has a reference to self
              remove-references-to -t $out $out/lib/*.a
            ''
          else
            ''
              # If we're building dynamic libraries, then don't install static
              # libraries.
              if [ -n "$(echo $out/lib/*.so $out/lib/*.dylib $out/lib/*.dll)" ]; then
                  rm "$out/lib/"*.a
              fi

              # 'etc' is a separate output on static builds only.
              etc=$out
            ''
        )
        + ''
          mkdir -p $bin
          mv $out/bin $bin/bin

        ''
        +
        lib.optionalString (!stdenv.hostPlatform.isWindows)
          # makeWrapper is broken for windows cross (https://github.com/NixOS/nixpkgs/issues/120726)
          ''
            # c_rehash is a legacy perl script with the same functionality
            # as `openssl rehash`
            # this wrapper script is created to maintain backwards compatibility without
            # depending on perl
            makeWrapper $bin/bin/openssl $bin/bin/c_rehash \
              --add-flags "rehash"
          ''
        + ''

          mkdir $dev
          mv $out/include $dev/

          # remove dependency on Perl at runtime
          rm -r $etc/etc/ssl/misc

          rmdir $etc/etc/ssl/{certs,private}
        ''
        + lib.optionalString (conf != null) ''
          cat ${conf} > $etc/etc/ssl/openssl.cnf
        '';

      postFixup =
        lib.optionalString (!stdenv.hostPlatform.isWindows) ''
          # Check to make sure the main output and the static runtime dependencies
          # don't depend on perl
          if grep -r '${buildPackages.perl}' $out $etc; then
            echo "Found an erroneous dependency on perl ^^^" >&2
            exit 1
          fi
        ''
        + lib.optionalString (lib.versionAtLeast version "3.3.0") ''
          # cleanup cmake helpers for now (for OpenSSL >= 3.3), only rely on pkg-config.
          # pkg-config gets its paths fixed correctly
          rm -rf $dev/lib/cmake
        '';

      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

      meta = {
        homepage = "https://www.openssl.org/";
        changelog = "https://github.com/openssl/openssl/blob/openssl-${version}/CHANGES.md";
        description = "Cryptographic library that implements the SSL and TLS protocols";
        license = lib.licenses.openssl;
        mainProgram = "openssl";
        maintainers = with lib.maintainers; [ thillux ] ++ lib.teams.stridtech.members;
        pkgConfigModules = [
          "libcrypto"
          "libssl"
          "openssl"
        ];
        platforms = lib.platforms.all;
      } // extraMeta;
    });

in
common {
  version = "3.4.0";
  hash = "sha256-4V3agv4v6BOdwqwho21MoB1TE8dfmfRsTooncJtylL8=";

  patches = [
    ./nix-ssl-cert-file.patch

    # openssl will only compile in KTLS if the current kernel supports it.
    # This patch disables build-time detection.
    ./openssl-disable-kernel-detection.patch

    (
      if stdenv.hostPlatform.isDarwin then
        ./use-etc-ssl-certs-darwin.patch
      else
        ./use-etc-ssl-certs.patch
    )

    ./correct_registers_for_aarch64.patch
  ];

  withDocs = true;

  extraMeta = {
    license = lib.licenses.asl20;
  };
}
