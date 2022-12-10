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
                    nixpkgs : at : structure-directory : scripts : hook : inputs :
                      let
                        _utils = builtins.getAttr system utils.lib ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
			structure =
			  let
			    in
			      {
			        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
			        scripts =
				  _utils.visitor
				    {
				      list = track : track.reduced ;
				      set = track : track.reduced ;
				      string = track : pkgs.writeText "script" ( utils.strip track.reduced ) ;
				    } ;
			        utils = _utils ;
			      } ;
                        in
                          pkgs.mkShell
                            {
			      buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name ( builtins.readFile value ) ) ( inputs ( scripts structure ) ) ) ;
			      shellHook = hook ( scripts structure ) ;
                            }
                  ) ;
              }
      ) ;
    }
