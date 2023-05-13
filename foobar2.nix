{ ... } :
  {
    perSystem = { pkgs , ... } : pkgs.writeShellScriptBin "foobar2" "${ pkgs.coreutils }/bin/true" ;
  }