{ pkgs, python, fonttools }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "opentype-feature-freezer";
  version = "1.32.2";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-zckzIL/uTi8UVUdvK1YY2C9HwNhlMvG2lnNmatzCtXM=";
  };
  doCheck = false;
  propagatedBuildInputs = [ fonttools ];
  meta = with pkgs.lib; {
    homepage = "https://pypi.org/project/opentype-feature-freezer";
    description = "Turns OpenType features 'on' by default in a font: reassigns the font's Unicode-to-glyph mapping fo permanently 'freeze' the 1-to-1 substitution features, and creates a new font.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nyxkrage ];
  };
}
