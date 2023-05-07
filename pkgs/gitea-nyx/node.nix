{ pkgs, giteaVersion, ... }:
let
  escapeSlash = str: builtins.replaceStrings [ "/" ] [ "\\/"] str;
in
pkgs.stdenv.mkDerivation rec {
  pname = "gitea-node-env";
  version = "${giteaVersion}-nyx";

  src = pkgs.fetchgit  {
    url = "https://gitea.pid1.sh/sanctureplicum/gitea.git";
    rev = "refs/tags/${giteaVersion}";
    hash = "sha256-KQEBq1BFQRLJW9fJq4W1sOsAqOCfNHKY/+cT8rkXxv4=";
  };

  nativeBuildInputs = [ pkgs.node2nix ];

  buildPhase = ''
    mkdir nix
    node2nix -i ${src}/package.json -l ${src}/package-lock.json
    sed -r -i 's/src = .+?nix\/store.+?;/src = fetchgit { url = "${escapeSlash src.url}"; rev = "${escapeSlash src.rev}"; hash = "${escapeSlash src.outputHash}"; };/' node-packages.nix
  '';

  installPhase = ''
    mkdir $out
    cp *.nix $out
  '';
}