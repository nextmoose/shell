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
                        structure =
                          {
			    pkgs = builtins.getAttr system nixpkgs.defaultPackages ;
                            scripts = _utils.visit
                              {
                                list = track : track.reduced ;
                                set = track : track.reduced ;
                                string = "${ pkgs.coreutils }/bin/echo PLACE HOLDER" ;
                              } scripts structure ;
                          } ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name value ) ( inputs ( structure.scripts ) ) ) ;
                              shellHook = hook structure.scripts ;
                            }
                  ) ;
              }
      ) ;
    }
