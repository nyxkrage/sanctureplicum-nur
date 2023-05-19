{ pkgs, ... }: pkgs.gitea.overrideAttrs (old: rec {
  pname = "gitea";
  version = "v1.20.0-dev";

  src = "${import ./build.nix { inherit pkgs; giteaVersion = version; }}/gitea-src-${version}-nyx.tar.gz";
})
