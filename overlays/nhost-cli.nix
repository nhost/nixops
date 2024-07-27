{ final }:
let
  version = "v1.20.0";
  dist = {
    aarch64-darwin = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-arm64.tar.gz";
      sha256 = "1k5bgi7nqpnlpb3fq03hihwk6qvk4ryh65ymw8als6mb2r92xcfd";
    };
    x86_64-darwin = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-amd64.tar.gz";
      sha256 = "07vfy87j3875fbbr5ssn0grnijiq3a7r7n0kjbh09dcig789a184";
    };
    aarch64-linux = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-arm64.tar.gz";
      sha256 = "1c5ma204dv75q21gvlx57h30ahgxajbs0v9sfzhxc17m8nx2yi3g";
    };
    x86_64-linux = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-amd64.tar.gz";
      sha256 = "0mn5yvpgj4ldwfvanr9k9inj78s9lvpb6jmrz6561cvz19ylhwii";
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

    # installShellCompletion --cmd nhost \
    #   --bash <($out/bin/nhost completion bash) \
    #   --fish <($out/bin/nhost completion fish) \
    #   --zsh <($out/bin/nhost completion zsh)

    runHook postInstall
  '';

  meta = with final.lib; {
    description = "Nhost CLI";
    homepage = "https://nhost.io";
    license = licenses.mit;
    maintainers = [ "@nhost" ];
  };

}
