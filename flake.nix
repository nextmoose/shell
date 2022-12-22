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
                            _utils = builtins.getAttr system utils.lib ;
                            fun =
                              numbers : variables :
                                let
                                  _scripts = _utils.visit
                                    {
                                      list = track : track.reduced ;
                                      set = track : track.reduced ;
                                      string = track : _utils.strip track.reduced ;
                                    } ( scripts structure ) ;
                                  structure =
                                    {
                                      pkgs = pkgs ;
                                      numbers = numbers.shared ;
                                      resources = _utils.visit
                                        {
                                          lambda = track : "${ pkgs.coreutils }/bin/echo PLACE HOLDER RESOURCES" ;
                                          list = track : track.reduced ;
                                          set = track : track.reduced ;
                                        } ( resources _scripts ) ;
                                      scripts = _scripts ;
                                      variables = variables.shared ;
                                    } ;
                                  in
                                    {
                                      hook = hook _scripts ;
                                      inputs =
                                        let
                                          scripts =
                                            _utils.visit
                                              {
                                                list = track : track.reduced ;
                                                set = track : track.reduced ;
                                                string =
                                                  track :
                                                    ''
                                                      if [ ! -d ${ structure-directory } ]
                                                      then
                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                      fi &&
                                                      ${ _utils.strip track.reduced }
                                                    '' ;
                                              } _scripts ;
                                          in builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name ( _utils.strip value ) ) ( inputs scripts ) ) ;
                                    } ;
                            zero =
                              let
                                raw =
                                  {
                                    numbers =
                                      {
                                        script = [ "structure" ] ;
                                      } ;
                                    variables =
                                      {
                                        script = [ "log" ] ;
                                        shared = [ "temporary" "din" "debug" "notes" ] ;
                                      } ;
                                  } ;
                                processed =
                                  _utils.visit
                                    {
                                      list = track : builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                      set = track : track.reduced ;
                                      string = track : { "${ _utils.strip track.reduced }" = "" ; } ;
                                    } raw ;
				variables =
				  let
				    indexed =
				      _utils.visit
				        {
					  list = track : builtins.concatLists track.reduced ;
					  set = track : builtins.concatLists ( builtins.attrValues track.reduced ) ;
					  string = track : [ null ] ;
					} raw.variables ;
				    seeded =
				      let
				        reducer =
					  previous : current :
					    _utils.try
					      (
					        seed :
						  let
						    token = builtins.concatStringsSep "_" [ "VARIABLE" ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] ;
						    in
						      {
						        success =
							  let
							    is-not-in-zero =
							      _utils.visit
							        {
								  list = track : builtins.all ( x : x ) track.reduced ;
								  set = track : builtins.all ( x : x ) ( builtins.attrValues track.reduced ) ;
								  string = track : builtins.replaceStrings [ token ] [ "" ] track.reduced == track.reduced ;
								} zero.scripts ;
							    is-unique = builtins.all ( p : p != token ) previous ;
							    in is-not-in-zero && is-unique ;
							value = token ;
						      }
					      ) ;
					in builtins.foldl' reducer [ ] indexed ;
				    in
				      _utils.visit
				        {
					  list = track : track.reduced ;
					  set = track : track.reduced ;
					  string = track : builtins.elemAt seeded track.index ;
					} raw.variables ;
                                zero =
				  let
                                    processed =
                                      _utils.visit
                                        {
                                          list = track : builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                          set = track : track.reduced ;
                                          string = track : { "${ _utils.strip track.reduced }" = "" ; } ;
                                        } raw ;
				    in fun processed.numbers processed.variables ;
				in fun processed.numbers processed.variables ;
                            in zero ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = _.inputs ;
                              shellHook = _.hook ;
                            }
                  ) ;
              }
      ) ;
    }
