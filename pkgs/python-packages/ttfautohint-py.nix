{ pkgs, python }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "ttfautohint-py";
  version = "0.5.1";
  src = pkgs.fetchurl {
    url = "https://files.pythonhosted.org/packages/95/13/fa29859804685619c0788a92a78ba624879ba618e67f25ffe30ca51bfb04/ttfautohint_py-0.5.1-py2.py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
    sha256 = "sha256-XGX+L9PuFtaCARacckE+cBMNn50LklifkSLZ9yqY0JM=";
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
