# sanctureplicum/nur

[![Cachix Cache](https://img.shields.io/badge/cachix-sanctureplicum-blue.svg)](https://sanctureplicum.cachix.org)

## What's available

| General Packages            | Note                              | Version |
| --------------------------- | --------------------------------- | ------- |
| [`gitea-nyx`][gitea-nyx]    | Personal Fork                     | 1.19.3  |
| [`rec-mono-nyx`][recursive] | Personal config of Recursive Mono | 1.0.0   |
| [`libspectre`][spectre]     |                                   | 1.0.0   |

| Firefox Addons                             | Note                             | Version |
| ------------------------------------------ | -------------------------------- | ------- |
| [`duplicate-tab-shortcut`][duplicate-tab]  |                                  | 1.5.3   |
| [`istilldontcareaboutcookies`][isdcac]     |                                  | 1.1.1   |
| [`masterpassword-firefox`][masterpassword] | Spectre, formerly MasterPassword | 2.9.5   |

| Emacs Packages                | Note  | Version |
| ----------------------------- | ----- | ------- |
| [`spectre-el`][spectre-emacs] |       | 0.3.0   |

## Usage

With `overlays`:

```nix
{
  inputs = {
    nur.url = "github:nix-community/NUR";
    sanctureplicum-nur.url = "git+https://gitea.pid1.sh/sanctureplicum/nur.git";
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    sanctureplicum-nur,
    ...
  }: let
    overlays = final: prev: {
      nur = import nur {
        nurpkgs = prev;
        pkgs = prev;
        repoOverrides = { sanctureplicum = import sanctureplicum-nur { pkgs = prev; }; };
      };
      # ... your other overlays
    };
  in {
    system = "x86_64-linux";

    modules = [
      ({ config, ... }: {
        config = {
          nixpkgs.overlays = [
            overlays
          ];
        };
      })
    ];
  };
}
```

[gitea-nyx]: https://gitea.pid1.sh/sanctureplicum/gitea
[recursive]: https://recursive.design
[spectre]: https://spectre.app
[duplicate-tab]: https://github.com/stefansundin/duplicate-tab
[isdcac]: https://github.com/OhMyGuus/I-Dont-Care-About-Cookies
[masterpassword]: https://github.com/ttyridal/masterpassword-firefox/wiki
[spectre-emacs]: https://github.com/nyxkrage/spectre-emacs