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
		      let
		        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
			in
		          pkgs.mkShell { shellHook = "${ pkgs.coreutils }/bin/echo HI ${ builtins.toString ( builtins.length ( builtins.attrValue { } ) ) }" ; }
		  ) ;
              }
      ) ;
    }
