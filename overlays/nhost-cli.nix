{ final }:
let
  version = "v1.24.1";
  dist = {
    aarch64-darwin = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-arm64.tar.gz";
      sha256 = "0j3kjz4hhxihg3w99qay74k8aslxnlgwvzvj8p3dindrd98h7pvn";
    };
    x86_64-darwin = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-amd64.tar.gz";
      sha256 = "118czg3pnj6j617dxvn5skl7012zadgq6ybkbhgcllwjk3glxavv";
    };
    aarch64-linux = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-arm64.tar.gz";
      sha256 = "1yj5zajaf2dfvflxkzfhnym2f2vpssmvd2d1kyb97ml8wqgw3mk9";
    };
    x86_64-linux = rec {
      url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-amd64.tar.gz";
      sha256 = "0m7h63clp0p4fycvyxad2mpwa6gfvr9s196j4lijbc1nfwqd4bp6";
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
