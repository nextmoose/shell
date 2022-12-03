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
                              list = track : builtins.concatStringsSep " &&" track.reduced ;
                              set = track : builtins.concatStringsSep " &&" ( builtins.attrValues track.reduced ) ;
                              string =
                                track :
                                  _utils.strip
                                    ''
                                      ${ pkgs.gnused }/bin/sed \
                                        -e "s#${ structure.loggers.note }#${ builtins.concatStringsSep "" [ "$" "{" "LOG_DIR" "}" ] }#" \
                                        -e "wscripts/${ builtins.toString track.index }" \
                                        ${ track.reduced }
                                    '' 
                            } ;
                        structure =
                          _utils.try
                            (
                              seed :
                                let
                                  fun =
                                    seed :
                                      let
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
                                            scripts =
                                              _utils.visit
                                                {
                                                  list = track : track.reduced ;
                                                  set = track : track.reduced ;
                                                  string = track : builtins.concatStringsSep "_" [ "SCRIPT" token ( pkgs.writeText "script" ( _utils.strip track.reduced ) ) ] ;
                                                } ( scripts ( fun seed ) ) ;
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
                                        ${ pkgs.coreutils }/bin/mkdir scripts &&
                                        ( ${ pkgs.coreutils }/bin/echo ${ builtins.concatStringsSep "" [ "\"" "$" "{" "FLAKE" "}" "\"" ] } > ${ builtins.concatStringsSep "" [ "$" "{" "SCRIPT_DIRECTORY" "}" ] }/hook.nix )
                                      ''
                                  )
                                ] ;
                              shellHook = "${ pkgs.coreutils }/bin/echo HELLO! ${ structure.scripts.program4 }" ;
                            }
                  ) ;
              }
      ) ;
    }
