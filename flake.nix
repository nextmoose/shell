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
                    nixpkgs : scripts : hook :
                      let
                        _utils = builtins.getAttr system utils.lib ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        structure =
                          _utils.try
                            (
                              seed :
                                let
				  eye = structure seed ;
				  structure =
				    seed :
				      let
				        token = builtins.hashString "sha512" ( builtins.toString seed ) ;
				        in
                                          {
                                            pkgs = pkgs ;
                                            resource-directory = token ;
                                            scripts = _utils.visit { list = track : track.processed ; set = track : track.processed ; string = track : track.processed ; } ( scripts structure seed ) ;
                                            token = token ;
                                            utils = _utils ;
                                          } ;
			            zero = structure 0 ;
                                    in
                                      {
                                        success = _utils.visit {
					  list = track : builtins.trace "builtins.all ( x : x ) track.processed" true ;
					  set = track : builtins.trace ( builtins.concatStringsSep "" builtins.map ( x : builtins.typeOf x ) ( builtins.attrValues track.processed ) ) true ;
					  string = set : track : builtins.trace "string ${ zero.token }" true ;
					  } ( structure 0 ) ;
                                        value = eye ;
                                      }
                            ) ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs =
                                [
                                  (
                                    pkgs.writeShellScriptBin
                                      "generate"
                                      ''
                                        while [ ${ builtins.concatStringsSep "" [ "$" "{" "#" "}" ] } -gt 0 ]
                                        do
                                          case ${ builtins.concatStringsSep "" [ "\"" "$" "{" "1" "}" "\"" ] } in
                                            resource-directory)
                                              RESOURCE_DIRECTORY=${ builtins.concatStringsSep "" [ "\"" "$" "{" "2" "}" "\"" ] } &&
                                                shift 2 &&
                                                break
                                            ;;
                                            private-file)
                                              PRIVATE_FILE=${ builtins.concatStringsSep "" [ "\"" "$" "{" "2" "}" "\"" ] } &&
                                                shift 2 &&
                                                break
                                            ;;
                                            *)
                                              ${ pkgs.coreutils }/bin/echo UNEXPECTED &&
                                                exit 64 &&
                                                break
                                            ;;
                                          esac
                                        done
                                       ''
                                  )
                                ] ;
                              shellHook = "${ pkgs.coreutils }/bin/echo HELLO! resource-directory = ${ structure.resource-directory }" ;
                            }
                  ) ;
              }
      ) ;
    }
