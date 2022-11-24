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
			utilsx = { } ;
			in
		          pkgs.mkShell { shellHook = "${ pkgs.coreutils }/bin/echo HELLO ${ builtins.toString ( builtins.length ( builtins.attrValues utilsx ) ) }" ; }
		  ) ;
              }
      ) ;
    }
