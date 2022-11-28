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
                                  fun =
                                    seed :
                                      let
                                        token = builtins.hashString "sha512" ( builtins.toString seed ) ;
                                        in
                                          {
                                            pkgs = pkgs ;
                                            resource-directory = token ;
                                            scripts = _utils.visit { list = track : track.reduced ; set = track : track.reduced ; string = track : track.reduced ; } ( scripts ( fun seed ) ) ;
                                            token = token ;
                                            utils = _utils ;
                                          } ;
                                    in
                                      {
				        success =
					  _utils.visit
					    {
					      set = track : builtins.trace "02 : ${ builtins.concatStringsSep " , " ( builtins.map ( value : if value then "Y" else "N" ) ( builtins.attrValues track.reduced ) ) } - ${ builtins.typeOf track.reduced.program3 }" true ;
					      string = track : builtins.replaceStrings [ ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] [ "" ] track.reduced == track.reduced ;
					    } ( scripts ( fun 0 ) ) ;
                                        success2 = _utils.visit {
                                          list = track : true ;
                                          set = track : builtins.all ( x : x ) ( builtins.attrValues track.reduced ) ;
                                          string = track : builtins.replaceStrings ( builtins.hashString "sha512" [ ( builtins.toString seed ) ] [ "" ] track.reduced ) == track.reduced ;
                                          } ( scripts ( fun 0 ) ) ;
                                        value = ( fun seed ) ;
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
                                            --resource-directory)
                                              RESOURCE_DIRECTORY=${ builtins.concatStringsSep "" [ "\"" "$" "{" "2" "}" "\"" ] } &&
                                                shift 2 &&
                                                break
                                            ;;
                                            --hook)
                                              HOOK=${ builtins.concatStringsSep "" [ "\"" "$" "{" "2" "}" "\"" ] } &&
                                                shift 2 &&
                                                break
                                            ;;
                                            --inputs)
                                              INPUTS=${ builtins.concatStringsSep "" [ "\"" "$" "{" "2" "}" "\"" ] } &&
                                                shift 2 &&
                                                break
                                            ;;
                                            --private-file)
                                              PRIVATE_FILE=${ builtins.concatStringsSep "" [ "\"" "$" "{" "2" "}" "\"" ] } &&
                                                shift 2 &&
                                                break
                                            ;;
                                             --scripts)
                                              SCRIPTS=${ builtins.concatStringsSep "" [ "\"" "$" "{" "2" "}" "\"" ] } &&
                                                shift 2 &&
                                                break
                                            ;;
                                            *)
                                              ${ pkgs.coreutils }/bin/echo UNEXPECTED &&
                                                exit 64 &&
                                                break
                                            ;;
                                          esac
                                        done &&
                                        SCRIPT_DIRECTORY=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
                                        ${ _utils.visit { list = track : builtins.concatStringsSep " &&\n" track.reduced ; set = track : builtins.concatStringsSep " &&\n" ( builtins.attrValues track.reduced ) ; string = track : "${ pkgs.gnused }/bin/sed -e \"s#${ structure.resource-directory }#${ builtins.concatStringsSep "" [ "$" "{" "RESOURCE_DIRECTORY" "}" ] }#g\" -e \"w${ builtins.concatStringsSep "" [ "$" "{" "SCRIPT_DIRECTORY" "}" ] }/${ builtins.toString track.index }\" ${ pkgs.writeText "script" track.reduced }" ; } structure.scripts } && ${ pkgs.coreutils }/bin/echo ${ builtins.concatStringsSep "" [ "$" "{" "SCRIPT_DIRECTORY" "}" ] } &&
                                        ${ pkgs.coreutils }/bin/echo ${ builtins.concatStringsSep "" [ "$" "{" "SCRIPT_DIRECTORY" "}" ] }
                                       ''
                                  )
                                ] ;
                              shellHook = "${ pkgs.coreutils }/bin/echo HELLO! token = ${ structure.token }" ;
                            }
                  ) ;
              }
      ) ;
    }
