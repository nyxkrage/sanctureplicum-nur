{ pkgs, python, ... }:
with builtins;
with pkgs.lib;
let
  pypi_fetcher_src = builtins.fetchTarball {
    name = "nix-pypi-fetcher-2";
    url = "https://github.com/DavHau/nix-pypi-fetcher-2/tarball/71a116a321a358fd0c30ab0e42cfc20eb47904a9";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "sha256-J7uKijlgDlkM+8EWEqzO8hg8rMyeVL62dWRKGcdHQ1I=";
  };
  pypiFetcher = import pypi_fetcher_src { inherit pkgs; };
  fetchPypi = pypiFetcher.fetchPypi;
  fetchPypiWheel = pypiFetcher.fetchPypiWheel;
  pkgsData = fromJSON ''{"font-v": {"name": "font-v", "ver": "1.0.5", "build_inputs": [], "prop_build_inputs": ["fonttools", "gitpython"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "font_v-1.0.5-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "fonttools": {"name": "fonttools", "ver": "4.17.0", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "fonttools-4.17.0-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "gitdb": {"name": "gitdb", "ver": "4.0.10", "build_inputs": [], "prop_build_inputs": ["smmap"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "gitdb-4.0.10-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "gitpython": {"name": "gitpython", "ver": "3.1.31", "build_inputs": [], "prop_build_inputs": ["gitdb"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "GitPython-3.1.31-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "opentype-feature-freezer": {"name": "opentype-feature-freezer", "ver": "1.32.2", "build_inputs": [], "prop_build_inputs": ["fonttools"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "opentype_feature_freezer-1.32.2-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "pyyaml": {"name": "pyyaml", "ver": "5.4.1", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "PyYAML-5.4.1-cp39-cp39-manylinux1_x86_64.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "skia-pathops": {"name": "skia-pathops", "ver": "0.7.0", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "skia_pathops-0.7.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "smmap": {"name": "smmap", "ver": "5.0.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "smmap-5.0.0-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "ttfautohint-py": {"name": "ttfautohint-py", "ver": "0.5.1", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "ttfautohint_py-0.5.1-py2.py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}}'';
  isPyModule = pkg:
    isAttrs pkg && hasAttr "pythonModule" pkg;
  normalizeName = name: (replaceStrings ["_"] ["-"] (toLower name));
  depNamesOther = [
    "depsBuildBuild"
    "depsBuildBuildPropagated"
    "nativeBuildInputs"
    "propagatedNativeBuildInputs"
    "depsBuildTarget"
    "depsBuildTargetPropagated"
    "depsHostHost"
    "depsHostHostPropagated"
    "depsTargetTarget"
    "depsTargetTargetPropagated"
    "checkInputs"
    "installCheckInputs"
  ];
  depNamesAll = depNamesOther ++ [
    "propagatedBuildInputs"
    "buildInputs"
  ];
  removeUnwantedPythonDeps = pythonSelf: pname: inputs:
    # Do not remove any deps if provider is nixpkgs and actual dependencies are unknown.
    # Otherwise we risk removing dependencies which are needed.
    if pkgsData."${pname}".provider_info.provider == "nixpkgs"
        &&
        (pkgsData."${pname}".build_inputs == null
            || pkgsData."${pname}".prop_build_inputs == null) then
      inputs
    else
      filter
        (dep:
          if ! isPyModule dep || pkgsData ? "${normalizeName (get_pname dep)}" then
            true
          else
            trace "removing dependency ${dep.name} from ${pname}" false)
        inputs;
  updatePythonDeps = newPkgs: pkg:
    if ! isPyModule pkg then pkg else
    let
      pname = normalizeName (get_pname pkg);
      newP =
        # All packages with a pname that already exists in our overrides must be replaced with our version.
        # Otherwise we will have a collision
        if newPkgs ? "${pname}" && pkg != newPkgs."${pname}" then
          trace "Updated inherited nixpkgs dep ${pname} from ${pkg.version} to ${newPkgs."${pname}".version}"
          newPkgs."${pname}"
        else
          pkg;
    in
      newP;
  updateAndRemoveDeps = pythonSelf: name: inputs:
    removeUnwantedPythonDeps pythonSelf name (map (dep: updatePythonDeps pythonSelf dep) inputs);
  cleanPythonDerivationInputs = pythonSelf: name: oldAttrs:
    mapAttrs (n: v: if elem n depNamesAll then updateAndRemoveDeps pythonSelf name v else v ) oldAttrs;
  override = pkg:
    if hasAttr "overridePythonAttrs" pkg then
        pkg.overridePythonAttrs
    else
        pkg.overrideAttrs;
  nameMap = {
    pytorch = "torch";
  };
  get_pname = pkg:
    let
      res = tryEval (
        if pkg ? src.pname then
          pkg.src.pname
        else if pkg ? pname then
          let pname = pkg.pname; in
            if nameMap ? "${pname}" then nameMap."${pname}" else pname
          else ""
      );
    in
      toString res.value;
  get_passthru = pypi_name: nix_name:
    # if pypi_name is in nixpkgs, we must pick it, otherwise risk infinite recursion.
    let
      python_pkgs = python.pkgs;
      pname = if hasAttr "${pypi_name}" python_pkgs then pypi_name else nix_name;
    in
      if hasAttr "${pname}" python_pkgs then
        let result = (tryEval
          (if isNull python_pkgs."${pname}" then
            {}
          else
            python_pkgs."${pname}".passthru));
        in
          if result.success then result.value else {}
      else {};
  allCondaDepsRec = pkg:
    let directCondaDeps =
      filter (p: p ? provider && p.provider == "conda") (pkg.propagatedBuildInputs or []);
    in
      directCondaDeps ++ filter (p: ! directCondaDeps ? p) (map (p: p.allCondaDeps) directCondaDeps);
  tests_on_off = enabled: pySelf: pySuper:
    let
      mod = {
        doCheck = enabled;
        doInstallCheck = enabled;
      };
    in
    {
      buildPythonPackage = args: pySuper.buildPythonPackage ( args // {
        doCheck = enabled;
        doInstallCheck = enabled;
      } );
      buildPythonApplication = args: pySuper.buildPythonPackage ( args // {
        doCheck = enabled;
        doInstallCheck = enabled;
      } );
    };
  pname_passthru_override = pySelf: pySuper: {
    fetchPypi = args: (pySuper.fetchPypi args).overrideAttrs (oa: {
      passthru = { inherit (args) pname; };
    });
  };
  mergeOverrides = with pkgs.lib; foldl composeExtensions (self: super: {});
  merge_with_overr = enabled: overr:
    mergeOverrides [(tests_on_off enabled) pname_passthru_override overr];
  select_pkgs = ps: [
    ps."font-v"
    ps."fonttools"
    ps."opentype-feature-freezer"
    ps."pyyaml"
    ps."skia-pathops"
    ps."ttfautohint-py"
  ];
  overrides' = manylinux1: autoPatchelfHook: merge_with_overr false (python-self: python-super: let all = {
    "font-v" = python-self.buildPythonPackage {
      pname = "font-v";
      version = "1.0.5";
      src = fetchPypiWheel "font-v" "1.0.5" "font_v-1.0.5-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "font-v" "font-v") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ fonttools gitpython ];
    };
    "fonttools" = python-self.buildPythonPackage {
      pname = "fonttools";
      version = "4.17.0";
      src = fetchPypiWheel "fonttools" "4.17.0" "fonttools-4.17.0-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "fonttools" "fonttools") // { provider = "wheel"; };
    };
    "gitdb" = python-self.buildPythonPackage {
      pname = "gitdb";
      version = "4.0.10";
      src = fetchPypiWheel "gitdb" "4.0.10" "gitdb-4.0.10-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "gitdb" "gitdb") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ smmap ];
    };
    "gitpython" = python-self.buildPythonPackage {
      pname = "gitpython";
      version = "3.1.31";
      src = fetchPypiWheel "gitpython" "3.1.31" "GitPython-3.1.31-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "gitpython" "GitPython") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ gitdb ];
    };
    "opentype-feature-freezer" = python-self.buildPythonPackage {
      pname = "opentype-feature-freezer";
      version = "1.32.2";
      src = fetchPypiWheel "opentype-feature-freezer" "1.32.2" "opentype_feature_freezer-1.32.2-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "opentype-feature-freezer" "opentype-feature-freezer") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ fonttools ];
    };
    "pyyaml" = python-self.buildPythonPackage {
      pname = "pyyaml";
      version = "5.4.1";
      src = fetchPypiWheel "pyyaml" "5.4.1" "PyYAML-5.4.1-cp39-cp39-manylinux1_x86_64.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pyyaml" "pyyaml") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreMissingDeps = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    "skia-pathops" = python-self.buildPythonPackage {
      pname = "skia-pathops";
      version = "0.7.0";
      src = fetchPypiWheel "skia-pathops" "0.7.0" "skia_pathops-0.7.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "skia-pathops" "skia-pathops") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreMissingDeps = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    "smmap" = python-self.buildPythonPackage {
      pname = "smmap";
      version = "5.0.0";
      src = fetchPypiWheel "smmap" "5.0.0" "smmap-5.0.0-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "smmap" "smmap") // { provider = "wheel"; };
    };
    "ttfautohint-py" = python-self.buildPythonPackage {
      pname = "ttfautohint-py";
      version = "0.5.1";
      src = fetchPypiWheel "ttfautohint-py" "0.5.1" "ttfautohint_py-0.5.1-py2.py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "ttfautohint-py" "ttfautohint-py") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreMissingDeps = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
  }; in all);
in
{
  inherit select_pkgs;
  overrides = overrides';
}
