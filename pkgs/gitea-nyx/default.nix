{ pkgs, ... }: pkgs.gitea.overrideAttrs (old: rec {
  pname = "gitea";
  version = "v1.19.3";

  src = "${import ./build.nix { inherit pkgs; giteaVersion = version; }}/gitea-src-${version}-nyx.tar.gz";
})