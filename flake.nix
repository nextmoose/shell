 {
    inputs =
      {
        bash-variable.url = "/home/emory/projects/5juNXfpb" ;
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843" ;
        scripts.url = "/home/emory/projects/61EJI0cs" ;
        strip.url = "/home/emory/projects/0TFnR2fJ" ;
        try.url = "/home/emory/projects/0gG3HgHu" ;
	unique.url = "/home/emory/projects/Rjgo3R5c" ;
        visit.url = "/home/emory/projects/wHpYNJk8" ;
      } ;
    outputs =
      { bash-variable , flake-utils , nixpkgs , self , scripts , strip , try , unique , visit } :
        {
          lib =
	    { hook , inputs , resources } :
	      flake-utils.lib.eachDefaultSystem
	        (
		  system :
		    let
		      pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
		      in
		        {
			  devShell = pkgs.mkShell { } ;
			}
		) ;
        } ;
  }