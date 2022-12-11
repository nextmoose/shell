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
                    nixpkgs : at : urandom : structure-directory : scripts : hook : inputs :
                      let
                        _utils = builtins.getAttr system utils.lib ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        structure =
                          _utils.try
                            (
                              seed :
                                let
                                  structure =
                                    seed :
                                      let
                                        _scripts =
                                          _utils.visit
                                            {
                                              lambda = track : track.reduced ( structure seed ) ;
                                              list = track : track.reduced ;
                                              set = track : track.reduced ;
                                            } scripts ;
                                        in
                                          {
					    programs =
					      _utils.visit
					        {
						  list = track : track.reduction ;
						  set = track : track.reduction ;
						  string = track : pkgs.writeShellScriptBin "script" track.reduced ;
						} _scripts ;
					    scripts = _scripts ;
					    urandom = urandom ;
                                          } ;
                                  in
                                    {
                                      success = seed > 2 ;
                                      value = structure seed ;
                                    }
                            ) ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name value ) ( inputs structure.programs ) ) ;
                              shellHook = hook structure.scripts ;
                            }
                  ) ;
              }
      ) ;
    }
