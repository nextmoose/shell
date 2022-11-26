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
		    nixpkgs : scripts : hook :
		      let
		        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;	  
			structure =
			  let
			    _utils = builtins.getAttr system utils.lib ;
			    in
			      {
			        pkgs = pkgs ;
			        scripts = _utils.visit { set = track : track.processed ; string = track : track.processed ; } ( scripts structure ) ;
			        utils = _utils ;
			      } ;
			in
		          pkgs.mkShell
			    {
			      buildInputs = [ ] ;
			      shellHook = hook ( structure.scripts ) ;
			    }
		  ) ;
              }
      ) ;
    }
