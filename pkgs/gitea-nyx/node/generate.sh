#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash node2nix curl nodePackages.npm
set -euo pipefail
IFS=$'\n\t'
if [ -n "${DEBUG:-}" ]; then set -x; fi


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VERSION=$(grep -Po 'version = "\K.+?(?=")' ../default.nix)
RAW_URL="https://gitea.pid1.sh/sanctureplicum/gitea/raw/tag/${VERSION}"
PACKAGES=("package.json" "package-lock.json")

for PACKAGE in ${PACKAGES[@]}; do
    curl -sSLf "$RAW_URL/$PACKAGE" -o "$SCRIPT_DIR/$PACKAGE"
done

npm --prefix "$SCRIPT_DIR" i --lockfile-version 2 --package-lock-only

node2nix -d -i "$SCRIPT_DIR/package.json" -l "$SCRIPT_DIR/package-lock.json" -o "$SCRIPT_DIR/node-packages.nix" -c "$SCRIPT_DIR/default.nix" -e "$SCRIPT_DIR/node-env.nix"
