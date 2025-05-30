{ final }:
let
  version = "v1.29.8";
  dist = {
    aarch64-darwin = {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-arm64.tar.gz";
      sha256 = "0m3hwnzvkv2kbhf1y2hfv2mhiwvcywi6jmq5d60fphhl1b3y99zm";
    };
    x86_64-darwin = {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-amd64.tar.gz";
      sha256 = "1bq66cbppw36jriwwrfqqvnaqn370vkr99jwhvb8cg0j79ly87xg";
    };
    aarch64-linux = {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-arm64.tar.gz";
      sha256 = "083fwr33l87y51w5wczv3269k7f0iq2srw8rbd3qw1xlwms9x6q3";
    };
    x86_64-linux = {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-amd64.tar.gz";
      sha256 = "08nhnnnbcv1mlbi2pigjgknyqyibp5xcp99z28am8qs2vi05kb93";
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
