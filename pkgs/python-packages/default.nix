{ pkgs }: rec {
  "font-v" = pkgs.callPackage ./font-v.nix { inherit  fonttools gitpython; };
  "fonttools" = pkgs.callPackage ./fonttools.nix { };
  "gitdb" = pkgs.callPackage ./gitdb.nix { inherit  smmap; };
  "gitpython" = pkgs.callPackage ./gitpython.nix { inherit  gitdb; };
  "opentype-feature-freezer" = pkgs.callPackage ./opentype-feature-freezer.nix { inherit  fonttools; };
  "pyyaml" = pkgs.callPackage ./pyyaml.nix { };
  "skia-pathops" = pkgs.callPackage ./skia-pathops.nix { };
  "smmap" = pkgs.callPackage ./smmap.nix { };
  "ttfautohint-py" = pkgs.callPackage ./ttfautohint-py.nix { };
}
