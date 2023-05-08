# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage



{ pkgs ? import <nixpkgs> { }
, system ? builtins.currentSystem
, mach-nixpkgs ? import (builtins.fetchTarball { url = "https://github.com/nixos/nixpkgs/archive/9fd0585f7dc9b85eb5d426396004cc649261e60d.tar.gz"; sha256 = "sha256:0xl9mc0p63jr490hnrmlky7rm13f7zmp2hp1d9bjfyrbwafsg4dv"; }) {}
, mach-nix ? import (builtins.fetchTarball { url = "https://github.com/davhau/mach-nix/archive/6cd3929b1561c3eef68f5fc6a08b57cf95c41ec1.tar.gz"; sha256 = "sha256:1a0gny4nlq39nyhgn94kl4rhmzax3h8xyh0jl7wrv0rzg38zf705"; }) {
    pkgs = mach-nixpkgs;
    pypiData = builtins.fetchTarball { url = "https://github.com/davhau/pypi-deps-db/archive/e9571cac25d2f509e44fec9dc94a3703a40126ff.tar.gz"; sha256 = "sha256:1rbb0yx5kjn0j6lk0ml163227swji8abvq0krynqyi759ixirxd5"; };
  }
}: {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  firefox-addons = pkgs.recurseIntoAttrs (pkgs.callPackage ./pkgs/firefox-addons { });
  gitea-nyx = import ./pkgs/gitea-nyx { inherit pkgs; };
  emacsPackages = pkgs.recurseIntoAttrs (pkgs.callPackage ./pkgs/emacs-packages { });
  pythonPackages = pkgs.recurseIntoAttrs (pkgs.callPackage ./pkgs/python-packages { });
  rec-mono-nyx = pkgs.callPackage ./pkgs/rec-mono-nyx { inherit mach-nix mach-nixpkgs system; };
  libspectre = pkgs.callPackage ./pkgs/libspectre { };
}
