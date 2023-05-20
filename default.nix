# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage



{ pkgs ? import <nixpkgs> { }
, system ? builtins.currentSystem
}: {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  firefox-addons = pkgs.recurseIntoAttrs (pkgs.callPackage ./pkgs/firefox-addons { });
  gitea-nyx = pkgs.callPackage ./pkgs/gitea-nyx { };
  emacsPackages = pkgs.recurseIntoAttrs (pkgs.callPackage ./pkgs/emacs-packages { });
  pythonPackages = pkgs.recurseIntoAttrs (pkgs.callPackage ./pkgs/python-packages { });
  rec-mono-nyx = pkgs.callPackage ./pkgs/rec-mono-nyx { inherit system; };
  libspectre = pkgs.callPackage ./pkgs/libspectre { };
}
