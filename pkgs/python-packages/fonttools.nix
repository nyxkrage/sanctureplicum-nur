{ pkgs, python }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "fonttools";
  version = "4.17.0";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-V3PO7X5KGLJsA4iLFIBmr7E62DDlr9NQnTwoLwHc2kw=";
    extension = "zip";
  };
  passthru = { };
  doCheck = false;
  meta = with pkgs.lib; {
    homepage = "https://pypi.org/project/fonttools";
    description = "Tools to manipulate font files";
    license = licenses.mit;
    maintainers = with maintainers; [ nyxkrage ];
  };
}
