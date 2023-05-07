{
  description = "My personal NUR repository";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.mach-nixpkgs.url = "github:nixos/nixpkgs/9fd0585f7dc9b85eb5d426396004cc649261e60d";
  inputs.mach-nix = {
    url = "github:davhau/mach-nix/6cd3929b1561c3eef68f5fc6a08b57cf95c41ec1";
    inputs.nixpkgs.follows = "mach-nixpkgs";
    inputs.pypi-deps-db = {
      url = "github:davhau/pypi-deps-db/e9571cac25d2f509e44fec9dc94a3703a40126ff";
      inputs.nixpkgs.follows = "mach-nixpkgs";
    };
  };
  outputs = { self, nixpkgs, mach-nixpkgs, mach-nix }:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      packages = forAllSystems (system: import ./default.nix {
        pkgs = import nixpkgs { inherit system; };
        mach-nixpkgs = import mach-nixpkgs { inherit system; };
        mach-nix = mach-nix.lib.${system};
        inherit system;
      });
    };
}
