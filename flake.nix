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
                                  structure =
				    seed :
                                      {
                                        pkgs = pkgs ;
                                        resource-directory = builtins.hashString "sha512" ( builtins.toString seed ) ;
                                        scripts = _utils.visit { list = track : track.processed ; set = track : track.processed ; string = track : track.processed ; } ( scripts structure seed ) ;
                                        utils = _utils ;
                                      } ;
                                  in
                                    {
                                      success = _utils.visit { list = track : builtins.all ( x : x ) track.processed ; set = track : builtins.all ( x : x ) ( builtins.attrValues track,processed ) ; string = track : builtins.replaceStrings [ ( builtins.hashString "sha512" seed ) ] [ "" ] track.processed == track.processed ; } ( scripts structure 0 ) ;
                                      value = structure seed ;
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
