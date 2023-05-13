  {
    inputs =
      {
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable" ;
      } ;
    outputs =
      { flake-utils , nixpkgs , self } :
        {
          lib =
	    { scripts } :
              flake-utils.lib.eachDefaultSystem
                (
                  system :
                    {
                      devShell =
                        let
                          pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                          in pkgs.mkShell { } ;
                    }
              ) ;
         } ;
  }
