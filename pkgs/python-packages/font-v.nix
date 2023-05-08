{ pkgs, python, fonttools, gitpython }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "font-v";
  version = "1.0.5";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-Vh9K3KUfH1p7ssVY2gTnw1+59A/7qQIOz4wGFo4VPF0=";
  };
  doCheck = false;
  passthru = { };
  propagatedBuildInputs = [ fonttools gitpython ];
  meta = with pkgs.lib; {
    homepage = "https://pypi.org/project/font-v";
    description = "font-v is an open source font version string library (libfv) and executable (font-v) for reading, reporting, modifying, and writing OpenType name table ID 5 records and head table fontRevision records in *.otf and *.ttf fonts.";
    license = licenses.mit;
    maintainers = with maintainers; [ nyxkrage ];
  };
}
