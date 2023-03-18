  {
      inputs =
        {
          bash-variable.url = "github:nextmoose/bash-variables?rev=f3379946326bc530c7987bfc0f296d367914b6a2" ;
          flake-utils.url = "github:numtide/flake-utils" ;
          strip.url = "github:nextmoose/strip?rev=944c89b12f368b93188606e2e41eab9d1338f2d7" ;
          try.url = "github:nextmoose/try?rev=5b20bf8efbf1155753130abfae6008ca319ef4ca" ;
          visit.url = "github:nextmoose/visit?rev=1f99dae8a13e8c53e9aae3b6bde2a8e8cb1c7161" ;
        } ;
      outputs =
        { bash-variable , flake-utils , self , strip , try , visit } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                lib =
                  builtins.foldl'
                    ( previous : current : previous ( builtins.getAttr system ( builtins.getAttr "lib" current ) ) )
                    (
                      bash-variable : strip : try : visit : nixpkgs : at : urandom : structure-directory : scripts : resources : hook : inputs :
                        let
                          pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                          _scripts =
                            let
                              lambda =
                                track :
				  let
				    structure =
				      let
				        seed =
					  try
					    (
					      seed :
					        {
					          success = builtins.replaceStrings [ ( builtins.toString seed ) ] [ "" ] string == string ;
					          value = seed ;
					        }
				            ) ;
				        structure =
					  seed :
					    {
				              pkgs = pkgs ;
				              seed = builtins.toString seed ;
				            } ;
					string = track.reduced ( structure 0 ) ;
				        in structure seed ;
				    in track.reduced structure ;
                              list = track : track.reduced ;
                              set = track : track.reduced ;
                              undefined = track : builtins.throw "1c7366e8-05ad-47a2-bc49-615acbfa985d" ;
                              in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } scripts ;
                          shell =
                            scripts :
                              pkgs.mkShell
                                {
                                  buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name value ) ( inputs scripts ) ) ;
                                  shellHook = "${ hook scripts }" ;
                                } ;
                          in shell _scripts
                    )
                    [ bash-variable strip try visit ] ;
              }
          ) ;
    }
