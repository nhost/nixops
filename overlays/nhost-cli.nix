{ final }:
let
  version = "v1.12.0";
  dist = {
    aarch64-darwin = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-arm64.tar.gz";
      sha256 = "sha256-aXKVUNjMJOGrLsxrMj21DGhfoz7nOv+iGJyAM5EZGAM=";
    };
    x86_64-linux = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-amd64.tar.gz";
      sha256 = "0jldxll6qm2c56aki5rbdn0z47g3pmvrk95gf5lsfqq28dvnymgw";
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
