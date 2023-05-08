{ pkgs, python, smmap }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "gitdb";
  version = "4.0.10";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-brmQtp304VutiZ6oaNxGVyw/dTOXNWY7gd55sG8X65o=";
  };
  doCheck = false;
  passthru = { };
  propagatedBuildInputs = [ smmap ];
  meta = with pkgs.lib; {
    homepage = "https://pypi.org/project/gitdb";
    description = "Git Object Database";
    license = licenses.bsd1;
    maintainers = with maintainers; [ nyxkrage ];
  };
}
