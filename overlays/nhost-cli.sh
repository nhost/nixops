#1/usr/bin/env bash

set -eou pipefail


version="$1"
echo "version: $version"

nix-prefetch-url --type sha256 https://github.com/nhost/cli/releases/download/"$version"/cli-"$version"-darwin-arm64.tar.gz
nix-prefetch-url --type sha256 https://github.com/nhost/cli/releases/download/"$version"/cli-"$version"-darwin-amd64.tar.gz
nix-prefetch-url --type sha256 https://github.com/nhost/cli/releases/download/"$version"/cli-"$version"-linux-arm64.tar.gz
nix-prefetch-url --type sha256 https://github.com/nhost/cli/releases/download/"$version"/cli-"$version"-linux-amd64.tar.gz
