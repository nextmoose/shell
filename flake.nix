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
                    nixpkgs : at : urandom : structure-directory : scripts : resources : hook : inputs :
                      let
                        _utils = builtins.getAttr system utils.lib ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        structure =
			  let
			    _scripts = _utils.visit
			      {
			        list = track : track.reduced ;
				set = track : track.reduced ;
				string = track : "${ pkgs.coreutils }/bin/echo PLACE HOLDER _SCRIPTS" ;
			      } ( scripts structure ) ;
			    in
                          {
                            pkgs = pkgs ;
                            resources = _utils.visit
			      {
			        lambda = track : "${ pkgs.coreutils }/bin/echo PLACE HOLDER RESOURCES" ;
			        list = track : track.reduced ;
				set = track : track.reduced ;
			      } ( resources _scripts ) ;
                            scripts = _scripts ;
                          } ;
                        in
                          pkgs.mkShell
                            {
                              shellHook = hook structure.scripts ;
                            }
                  ) ;
              }
      ) ;
    }
