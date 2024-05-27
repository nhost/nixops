{ final }:
let
  version = "v1.18.0";
  dist = {
    aarch64-darwin = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-arm64.tar.gz";
      sha256 = "1r94lqxhjb2far3w7pc7qwjy31047r49f105xz953v044fz2is7d";
    };
    x86_64-darwin = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-amd64.tar.gz";
      sha256 = "17w1jhn1zy4pvnbwky0p80kqggwfr0nn4jmv2860hgf8ar8h293l";
    };
    aarch64-linux = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-arm64.tar.gz";
      sha256 = "1gj1qrsw9d9vbiqlgz4ds8wkp2bri19kj503m2fj863bzl16jkxh";
    };
    x86_64-linux = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-amd64.tar.gz";
      sha256 = "0fsdnys74n8wppljsp4hmq5bqdn3c98p2hgqsifxj7h7kfjrzyd8";
    };
  };

in
final.stdenvNoCC.mkDerivation rec {
  pname = "nhost-cli";
  inherit version;

  src = final.fetchurl {
    inherit (dist.${final.stdenvNoCC.hostPlatform.system} or
      (throw "Unsupported system: ${final.stdenvNoCC.hostPlatform.system}")) url sha256;
  };


  sourceRoot = ".";

  nativeBuildInputs = [
    final.unzip
    final.makeWrapper
    final.installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv cli $out/bin/nhost

    installShellCompletion --cmd nhost \
      --bash <($out/bin/nhost completion bash) \
      --fish <($out/bin/nhost completion fish) \
      --zsh <($out/bin/nhost completion zsh)

    runHook postInstall
  '';

  meta = with final.lib; {
    description = "Nhost CLI";
    homepage = "https://nhost.io";
    license = licenses.mit;
    maintainers = [ "@nhost" ];
  };

}
