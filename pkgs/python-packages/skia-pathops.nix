{ pkgs }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "skia-pathops";
  version = "0.7.0";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-QRKbU3eJr+LxuT9vQ+SgWM0d/1gEWn5WFq1cvbgM1U0=";
    extension = "zip";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "build_cmd = [sys.executable, build_skia_py, build_dir]" \
        'build_cmd = [sys.executable, build_skia_py, "--no-fetch-gn", "--no-virtualenv", "--gn-path", "${pkgs.gn}/bin/gn", build_dir]'
  '' + pkgs.lib.optionalString (pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64) ''
    substituteInPlace src/cpp/skia-builder/skia/gn/skia/BUILD.gn \
      --replace "-march=armv7-a" "-march=armv8-a" \
      --replace "-mfpu=neon" "" \
      --replace "-mthumb" ""
    substituteInPlace src/cpp/skia-builder/skia/src/core/SkOpts.cpp \
      --replace "defined(SK_CPU_ARM64)" "0"
  '';

  nativeBuildInputs = [ pkgs.python39.pkgs.cython pkgs.ninja pkgs.python39.pkgs.setuptools-scm ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.xcodebuild ];

  buildInputs = pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.ApplicationServices pkgs.OpenGL ];

  propagatedBuildInputs = [ pkgs.python39.pkgs.setuptools ];

  pythonImportsCheck = [ "pathops" ];

  meta = with pkgs.lib; {
    homepage = "https://pypi.org/project/skia-pathops";
    description = "Python bindings for the Google Skia library's Path Ops module, performing boolean operations on paths (intersection, union, difference, xor).";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nyxkrage ];
  };
}
