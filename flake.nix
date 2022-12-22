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
                        _ =
                          let
                            _scripts = _utils.visit
                              {
                                list = track : track.reduced ;
                                set = track : track.reduced ;
                                string = track : "${ pkgs.coreutils }/bin/echo PLACE HOLDER _SCRIPTS" ;
                              } ( scripts structure ) ;
                            structure =
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
                            _utils = builtins.getAttr system utils.lib ;
                            in
                              {
                                hook = hook _scripts ;
                              } ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        in
                          pkgs.mkShell
                            {
                              shellHook = _.hook ;
                            }
                  ) ;
              }
      ) ;
    }
