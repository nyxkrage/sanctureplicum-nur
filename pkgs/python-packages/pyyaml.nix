{ pkgs, python }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "PyYAML";
  version = "5.4.1";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-YHd0y7oocyv6gCtUuqdIQhX1MJkQVbtWLvvtWy8gpF4=";
  };
  passthru = { };
  doCheck = false;
  meta = with pkgs.lib; {
    homepage = "https://pypi.org/project/pyyaml";
    description = "YAML parser and emitter for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ nyxkrage ];
  };
}
