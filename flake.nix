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
			_scripts =
			  _utils.visit
			    {
			      lambda =
			        track :
				  let
				    base =
				      {
				        numbers = [ "structure" "logs" "log" "stderr" ] ;
					variables = [ "structure" "stdout" "stderr" "din" "debug" "notes" "temporary" ] ;
				      } ;
			            string =
				      let
				        attrs = src : builtins.listToAttrs ( builtins.map mapper src ) ;
				        mapper = item : { name = item; value = "" ; } ;
					_structure = structure ( attrs base.numbers ) ( attrs base.variables ) ;
					in track.reduced _structure ;
				    structure =
				      numbers : variables :
				        let
					  in
					    {
					      numbers = numbers ;
					      pkgs = pkgs ;
					      variables = variables ;
					    } ;
				    in string ;
			      list = track : track.reduced ;
			      set = track : track.reduced ;
			    } scripts ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        in
                          pkgs.mkShell
                            {
                              shellHook = hook _scripts ;
                            }
                  ) ;
              }
      ) ;
    }
