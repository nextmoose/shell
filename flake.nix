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
		        structure =
			  _utils.visit
			    {
			      lambda = track :
			      list = track : track.reduced ;
			      set = track : track.reduced ;
			    } scripts ;
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
