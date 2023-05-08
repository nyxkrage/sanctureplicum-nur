{ pkgs, python, gitdb }: pkgs.python39.pkgs.buildPythonPackage rec {
  pname = "GitPython";
  version = "3.1.31";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-jOO89prf33x9UD54/TscSSr3gtWIk7ZQrbKsiRLd1XM=";
  };
  doCheck = false;
  passthru = { };
  propagatedBuildInputs = [ gitdb ];
  meta = with pkgs.lib; {
    homepage = "https://pypi.org/project/gitpython";
    description = "GitPython is a Python library used to interact with Git repositories";
    license = licenses.bsd1;
    maintainers = with maintainers; [ nyxkrage ];
  };
}
