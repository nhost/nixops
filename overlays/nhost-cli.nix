{ final }:
let
  version = "v1.29.7";
  dist = {
    aarch64-darwin = {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-arm64.tar.gz";
      sha256 = "00pr4p3a7h534nrvyd4jljij2h8jn2sw8pypnj0zn60cwc38wzxj";
    };
    x86_64-darwin = {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-amd64.tar.gz";
      sha256 = "1hj21xhkxayf73xh57ldj5g5sgmv3lb5kw37p3l86q6r2in3x486";
    };
    aarch64-linux = {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-arm64.tar.gz";
      sha256 = "1wgn6wvq2xlmf3i3hid31znzpln93q87kzn2wsqb2grl1bjkak1y";
    };
    x86_64-linux = {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-amd64.tar.gz";
      sha256 = "0cn6bp3cdpjpiak7pbjqrcyrkszlj7h4a2drawbs258amd8q2m5k";
    };
  };

in
final.stdenvNoCC.mkDerivation {
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
