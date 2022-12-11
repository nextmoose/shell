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
				    one =
				      let
				        numbers = builtins.foldl' reducers.numbers { } base.numbers ;
					reducers =
					  let
					    string = track.reduced zero ;
					    in
					      {
					        numbers =
					          previous : current :
					            _utils.try
						      (
						        seed :
						          let
					                    seed-string = builtins.toString seed ;
						            in
							      {
						                success =
							          let
							            is-not-in-string = builtins.replace [ seed-string ] [ "" ] string == string ;
							            is-not-duplicate = builtins.all ( p : p != seed-string ) previous ;
							            is-not-small = seed > 2 ;
							            in is-not-duplicate && is-not-small && is-not-in-string ;
							        value = seed-string ;
						              }
						      ) ;
						variables =
						  previous : current :
						    _utils.try
						      (
						        seed :
							  let
							    hash-string = builtins.hashString "sha512" ( builtins.toString seed ) ;
							    in
							      {
							        success =
								  let
								    is-not-in-string = builtins.replace [ hash-string ] [ "" ] string == string ;
								    is-not-duplicate = builtins.all ( p : p != hash-string ) previous ;
								    in is-not-in-string && is-not-duplicate ;
								value = hash-string ;
							      }
						      ) ;
					  } ;
					variables = builtins.foldl' reducers.variables { } base.variables ;
				        in structure numbers variables ;
				    structure =
				      numbers : variables :
				        let
					  commands =
					    _utils.visit
					      {
					      } procedures ;
					  procedures =
					    _utils.visit
					      {
					        list = track : track.reduced ;
						set = track : track.reduced ;
						string =
						  ''
						    ${ pkgs.makeShellScriptBin "script" ( _utils.strip track.reduced ) }/bin/script
						  '' ;
					      } _scripts ;
					  in
					    {
					      commands = commands ;
					      numbers = numbers ;
					      pkgs = pkgs ;
					      procedures = procedures ;
					      variables = variables ;
					    } ;
			            zero =
				      let
				        mapper = item : { name = item ; value = "" ; } ;
					in structure ( builtins.listToAttrs ( builtins.map mapper base.numbers ) ) ( builtins.listToAttrs ( builtins.map mapper base.variables ) ) ; 
				    in track.reduced one ;
			      list = track : track.reduced ;
			      set = track : track.reduced ;
			    } scripts ;
                        _utils = builtins.getAttr system utils.lib ;
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
