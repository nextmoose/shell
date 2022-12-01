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
                    nixpkgs : scripts : hook : at :
                      let
                        _utils = builtins.getAttr system utils.lib ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        sed =
                          _utils.visit
                            {
                              set = track : builtins.concatStringsSep " &&\n" ( builtins.attrValues track.reduced ) ;
                              string =
                                track :
				  _utils.strip
                                    ''
                                      ${ pkgs.gnused }/bin/sed \
                                        -e "s#${ structure.structure-directory }#${ builtins.concatStringsSep "" [ "$" "{" "STRUCTURE_DIRECTORY" "}" ] }#g" \
                                        -e "w${ builtins.concatStringsSep "" [ "$" "{" "SCRIPT_DIRECTORY" "}" ] }/scripts/${ builtins.toString track.index } \
					${ pkgs.writeShellScriptBin "script" track.reduced }/bin/script
                                    '' ;
                            } structure.scripts ;
                        structure =
                          _utils.try
                            (
                              seed :
                                let
                                  fun =
                                    seed :
                                      let
                                        logger =
                                          script :
					    let
					      log-directory = builtins.concatStringsSep "_" [ "LOGS" token ] ;
					      in
                                                ''
                                    		  if [ ! -d ${ structure-directory } ]
                                                  then
                                                    ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                  fi &&
                                                  if [ ! -d ${ structure-directory }/logs ]
                                                  then
                                                    ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logs
                                                  fi &&
						  cleanup ( )
						  {
						    ${ pkgs.coreutils }/bin/echo
						  } &&
                                                  ${ log-directory }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/logs/XXXXXXXX ) &&
					          exec 10 > ${ builtins.concatStringsSep "" [ "$" "{" log-directory "}" ] }/lock &&
					          ${ pkgs.flock }/bin/flock -n 10  &&
					          ${ pkgs.writeShellScriptBin "script" script }/bin/script > ${ log-directory }/out 2> ${ log-directory }/err
                                                '' ;
				        loggers =
					  {
					    err = "/dev/stderr" ;
					    out = "/dev/stdout" ;
					    din = builtins.concatStringsSep "_" [ "DIN" structure-directory ] ;
					    note = builtins.concatStringsSep "_" [ "NOTE" structure-directory ] ;
					  } ;
					structure-directory = builtins.concatStringsSep "_" [ "STRUCTURE" token ] ;
					temporary-directory = builtins.concatStringsSep "_" [ "TEMPORARY" token ] ;
                                        token = builtins.hashString "sha512" ( builtins.toString seed ) ;
                                        in
                                          {
					    loggers = loggers ;
                                            pkgs = pkgs ;
                                            scripts = _utils.visit { list = track : track.reduced ; set = track : track.reduced ; string = track : logger track.reduced ; } ( scripts ( fun seed ) ) ;
                                            structure-directory = structure-directory ;
					    temporary-directory = temporary-directory ;
                                            token = token ;
                                            utils = _utils ;
                                          } ;
                                    in
                                      {
                                        success =
                                          _utils.visit
                                            {
                                              set = track : builtins.all ( x : x ) ( builtins.attrValues track.reduced ) ;
                                              string = track : builtins.replaceStrings [ ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] [ "" ] track.reduced == track.reduced ;
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
                                            --structure-directory)
                                              STRUCTURE_DIRECTORY=${ builtins.concatStringsSep "" [ "\"" "$" "{" "2" "}" "\"" ] } &&
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
                                            *)
                                              ${ pkgs.coreutils }/bin/echo UNEXPECTED &&
                                                exit 64 &&
                                                break
                                            ;;
                                          esac
                                        done &&
                                        SCRIPT_DIRECTORY=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
                                        cd ${ builtins.concatStringsSep "" [ "$" "{" "SCRIPT_DIRECTORY" "}" ] } &&
                                        ${ pkgs.nix }/bin/nix flake init &&
                                        ( ${ pkgs.coreutils }/bin/cat > ${ builtins.concatStringsSep "" [ "$" "{" "SCRIPT_DIRECTORY" "}" ] }/flake.nix <<EOF
                                          {
                                            inputs =
                                              {
                                                nixpkgs.url = "github:nixos/nixpkgs" ;
                                                flake-utils.url = "github:numtide/flake-utils" ;
                                              } ;
                                            outputs =
                                              { self , nixpkgs ,flake-utils } :
                                                flake-utils.lib.eachDefaultSystem
                                                  (
                                                    system :
                                                      {
                                                        devShell =
                                                          let
                                                            pkgs = builtins.getAttr system nixpkgs.legacyPackages  ;
                                                            in pkgs.mkShell { shellHook = "${ pkgs.coreutils }/bin/echo HELLO" ; } ;
                                                      }
                                                   ) ;
                                          }      
                                        EOF
                                        ) &&
                                        ${ pkgs.coreutils }/bin/mkdir scripts &&
                                        ${ sed } &&
                                        ( ${ pkgs.coreutils }/bin/echo ${ builtins.concatStringsSep "" [ "\"" "$" "{" "FLAKE" "}" "\"" ] } > ${ builtins.concatStringsSep "" [ "$" "{" "SCRIPT_DIRECTORY" "}" ] }/hook.nix )
                                      ''
                                  )
                                ] ;
                              shellHook = "${ pkgs.coreutils }/bin/echo HELLO! token = ${ structure.token } ${ pkgs.at } && ${ pkgs.coreutils }/bin/echo ${ pkgs.writeShellScriptBin "hook" "${ pkgs.coreutils }/bin/touch 701d5da2-d075-4787-9872-7bb247878dfd" }/bin/hook | ${ at }/bin/at now" ;
                            }
                  ) ;
              }
      ) ;
    }
