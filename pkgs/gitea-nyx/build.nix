{ pkgs, giteaVersion, ... }:
let
  nodeEnv = (pkgs.callPackage ./node { });
in
pkgs.buildGoModule  rec {
  pname = "gitea-build";
  version = "${giteaVersion}-nyx";
  vendorSha256 = "sha256-e/16nUf4L7O23VhHdrFzc7c+E52CF6PQ8QcsyQD7LhA=";

  src = pkgs.fetchgit {
    url = "https://gitea.pid1.sh/sanctureplicum/gitea.git";
    rev = "refs/tags/${giteaVersion}";
    sha256 = "sha256-ovSDna7We1DTwkk8mD0Dhkfcyb6z2QnLDPRYkhHgiR0=";
  };

  nativeBuildInputs = [
    pkgs.gnumake
    pkgs.go
    pkgs.nodejs
    pkgs.nodePackages.npm
    pkgs.git
  ];

  buildPhase = ''
    ln -s ${nodeEnv.nodeDependencies}/lib/node_modules ./node_modules
    export PATH="${nodeEnv.nodeDependencies}/bin:$PATH"
    TAGS="bindata" VERSION="${version}" make frontend vendor generate release-sources 
    rm -rf $HOME
  '';

  installPhase = ''
    mkdir -p $out
    cp dist/release/gitea-src-${version}.tar.gz $out
  '';

  outputs = [ "out" ];

  enableParallelBuilding = false;

  meta = with pkgs.lib; {
    description = "Build helper for Gitea";
    homepage = "https://gitea.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ nyxkrage ];
    platforms = platforms.all;
  };
}
