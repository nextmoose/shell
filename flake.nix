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
		    nixpkgs : scripts :
		      let
		        _ = utilsx.visit { string = track : track.input ; } ( scripts structure ) ;
		        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
			structure =
			  {
			    pkgs = pkgs ;
			  } ;
			utilsx = builtins.getAttr system utils.lib ;
			in
		          pkgs.mkShell { shellHook = "${ pkgs.coreutils }/bin/echo ${ builtins.typeOf ( builtins.elemAt _ 0 ) }" ; }
		  ) ;
              }
      ) ;
    }
