#!/usr/bin/env bash

set -euo pipefail
set -x

tmpDir=$(mktemp -d)
cleanup() {
  rm -rf "$tmpDir"
}
trap cleanup EXIT

read -r target < /proc/sys/kernel/hostname
if [[ -z $target ]]; then
  target=default
fi
target=${1:-$target}
hostname=${1:-$target}
action=$2

flake="."
flakeAttr="nixosConfigurations.\"$target\".config.system.build.toplevel"
nix -L build "$flake#$flakeAttr" --out-link $tmpDir/result

#NIX_SSHOPTS="-t" nixos-rebuild $action \
#  --targetHost "$target.o" \
#  --use-remote-sudo
#
pathToConfig=$(readlink -f $tmpDir/result)

case "$action" in
  build)
    ;;
  switch|boot|test|dry-activate)
    nix -L copy --to "ssh://$target.o" "$flake#$flakeAttr"
    ssh -t $target.o sudo "$pathToConfig/bin/switch-to-configuration" "$action"
    ;;
esac
