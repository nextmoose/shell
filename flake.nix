  {
      inputs =
        {
          flake-utils.url = "github:numtide/flake-utils" ;
        } ;
      outputs =
        { self , flake-utils } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
	        lib =
		  (
		    nixpkgs :
		      builtins.getAttr "mkShell" ( builtins.getAttr system nixpkgs.legacyPackages ) { shellHook = "HI" ; }
		  ) ;
              }
      ) ;
    }
