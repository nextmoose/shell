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
		    scripts-function = ( builtins.import ./scripts.nix ) ;
		    scripts = scripts-function { boot = { hello = pkgs.writeShellScriptBin "${ pkgs.coreutils }/bin/echo HELLO" ; } ; } ;
		    structure-directory = import ./structure-directory.nix ;
		    token = import ./token.nix ;
		      in pkgs.mkShell
		        {
			  buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name value ) ( builtins.import ./inputs.nix scripts ) ) ;
			  shellHook = builtins.import ./hook.nix scripts ;
			} ;
              }
          ) ;
    }
