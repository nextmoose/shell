  {
      inputs =
        {
          flake-utils.url = "github:numtide/flake-utils" ;
          nixpkgs.url = "github:nixos/nixpkgs" ;
        } ;
      outputs =
        { self , flake-utils , nixpkgs } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                devShell =
		  let
		    pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
		    scripts = builtins.import scripts.tex ;
		      in pkgs.mkShell
		        {
			  buildInputs = builtins.attrValues ( builtins.map ( name : value : pkgs.writeShellScriptBin name value ; ) ( builtins.import ./inputs.nix scripts ) ;
			  shellHook = builtins.import ./hook.nix scripts ;
			}
              }
      ) ;
    }
