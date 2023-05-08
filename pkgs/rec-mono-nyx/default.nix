{ pkgs
, ...
}: pkgs.stdenv.mkDerivation rec {
  pname = "rec-mono-nyx";
  version = "1.0.0";

  src = pkgs.fetchgit {
    url = "https://github.com/arrowtype/recursive-code-config.git";
    rev = "c20977eb1f3cd59ca7ce03a740b4745f0d299b27";
    sha256 = "sha256-OaYhOCpjOZI3cIPUNhppqGAQOrGwuQ09tl1pXCtNj5s=";
  };

  recConfig = builtins.toJSON {
    "Family Name" = "Nyx";
    Fonts = {
      Regular = {
        MONO = 1;
        CASL = 1;
        wght = 500;
        slnt = 0;
        CRSV = 0;
      };

      Italic = {
        MONO = 1;
        CASL = 1;
        wght = 500;
        slnt = -12;
        CRSV = 0;
      };

      Bold = {
        MONO = 1;
        CASL = 1;
        wght = 800;
        slnt = 0;
        CRSV = 0;
      };

      "Bold Italic" = {
        MONO = 1;
        CASL = 1;
        wght = 800;
        slnt = -12;
        CRSV = 0;
      };
    };
    "Code Ligatures" = false;
    Features = [
      "ss01"
      "ss02"
      "ss03"
      "ss04"
      "ss05"
      "ss06"
      "ss08"
      "ss10"
      "ss11"
      "ss12"
    ];
  };
  
  nativeBuildInputs = let
    python = pkgs.python39;
    result = import ./py {inherit pkgs python;};
    manylinux1 = pkgs.pythonManylinuxPackages.manylinux1;
    overrides = result.overrides manylinux1 pkgs.autoPatchelfHook;
    py = pkgs.python39.override { packageOverrides = overrides; };
  in [
    (py.withPackages (ps: with ps; [ 
      font-v
      fonttools
      opentype-feature-freezer
      pyyaml
      skia-pathops
      ttfautohint-py
      setuptools
     ]))
  ];

  outputs = [ "out" ];
  phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    echo '${recConfig}' > config.yaml
    python3 scripts/instantiate-code-fonts.py
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp fonts/RecMonoNyx/* $out/share/fonts/truetype/
  '';

  meta = with pkgs.lib; {
    description = "Recusrive Mono - Nyx Style";
    homepage = "https://spectre.app/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ nyxkrage ];
    platforms = platforms.all;
  };
}
