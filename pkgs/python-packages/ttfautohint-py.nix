{ pkgs, python }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "ttfautohint-py";
  version = "0.5.1";
  src = pkgs.fetchurl {
    url = if pkgs.stdenv.isLinux then "https://files.pythonhosted.org/packages/95/13/fa29859804685619c0788a92a78ba624879ba618e67f25ffe30ca51bfb04/ttfautohint_py-0.5.1-py2.py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.whl" else "https://files.pythonhosted.org/packages/2c/37/1e1500aee15ce25c20e705d9ee34f4e9c5d8118050db973bca777139c3e7/ttfautohint_py-0.5.1-py2.py3-none-macosx_10_9_universal2.whl";
    sha256 = if pkgs.stdenv.isLinux then "sha256-XGX+L9PuFtaCARacckE+cBMNn50LklifkSLZ9yqY0JM=" else "sha256-EIKQezMRL3c0RJ9kyknVwyJaTGpycDQ1OIXllrHgoLA=";
  };
  format = "wheel";
  passthru = { };
  doCheck = false;
  nativeBuildInputs = [ pkgs.python39.pkgs.setuptools-scm ];
  meta = with pkgs.lib; {
    homepage = "https://pypi.org/project/ttfautohint-py";
    description = "Python wrapper for ttfautohint, a free auto-hinter for TrueType fonts";
    license = licenses.mit;
    maintainers = with maintainers; [ nyxkrage ];
  };
}
