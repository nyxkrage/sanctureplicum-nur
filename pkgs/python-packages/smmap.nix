{ pkgs }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "smmap";
  version = "5.0.0";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-yEDmIFnNO+IEsMnJ90viwJ1WSO3dRYDZMUw+zeCzCTY=";
  };
  doCheck = false;
  meta = with pkgs.lib; {
    homepage = "https://pypi.org/project/smmap";
    description = "A pure Python implementation of a sliding window memory map manager";
    license = licenses.bsd1;
    maintainers = with maintainers; [ nyxkrage ];
  };
}
