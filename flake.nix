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
			  {
			    pkgs = pkgs ;
			    scripts = builtins.getAttr "visit" ( builtins.getAttr system utils.lib ) ( scripts structure ) ;
			    utils = builtins.getAttr "lib" ( builtins.getAttr system utils.lib ) ;
			  } ;
			utilsx = builtins.getAttr system utils.lib ;
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
