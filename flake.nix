  {
      inputs =
        {
          flake-utils.url = "github:numtide/flake-utils" ;
	  utils.url = "github:nextmoose/utils" ;
        } ;
      outputs =
        { self , flake-utils , utils } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
	        lib =
		  (
		    nixpkgs :
		      let
		        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
			xutils = builtins.getAttr system utils.lib ;
			in
		          pkgs.mkShell { shellHook = "${ pkgs.coreutils }/bin/echo HI ${ builtins.toString ( builtins.length ( builtins.attrValue { } ) ) }" ; }
		  ) ;
              }
      ) ;
    }
