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
                        scripts-expression =
                          _utils.visit
                            {
                              list = track : "[ ${ builtins.concatStringsSep " " track.reduced } ]" ;
                              set = track : "{ ${ builtins.concatStringsSep "" ( builtins.attrValues ( builtins.mapAttrs ( name : value : "${ name } = ${ value } ; " ) track.reduced ) ) }}" ;
                              string = track : "builtins.readFile ./scripts/${ builtins.toString track.index }" ;
                            } ( scripts structure ) ;
                        sed-inner =
                          _utils.visit
                            {
                              list = track : builtins.concatStringsSep " \ \n" track.reduced ;
                              set = track : builtins.concatStringsSep " \ \n" ( builtins.attrValues track.reduced ) ;
                              string =
                                track :
                                  _utils.strip
                                    ''
                                      -e "s#${ pkgs.writeScript "script" ( _utils.strip track.reduced ) }#scripts/${ builtins.toString track.index }#g"
                                    '' ;
                            } ( scripts structure ) ;
                        sed-outer =
                          _utils.visit
                            {
                              list = track : builtins.concatStringsSep " && \n" track.reduced ;
                              set = track : builtins.concatStringsSep " && \n" ( builtins.attrValues track.reduced ) ;
                              string =
                                track :
                                  _utils.strip
                                    ''
                                      # OUTER :  ${ builtins.concatStringsSep " / " ( builtins.map builtins.toString track.path ) }
                                      ${ pkgs.coreutils }/bin/echo \
                                        ${ pkgs.gnused }/bin/sed \
                                        ${ sed-inner } \
                                        -e "wscripts/${ builtins.toString track.index }" \
                                        ${ pkgs.writeText "script" ( _utils.strip track.reduced ) } &&
                                      ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/chmod 0400 scripts/${ builtins.toString track.index } &&
                                      ${ pkgs.coreutils }/bin/echo ${ pkgs.git }/bin/git add scripts/${ builtins.toString track.index }
                                    '' ;
                            } ( scripts structure ) ;
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
                                              _utils.visitor
                                                {
                                                  list = track : track.reduced ;
                                                  set = track : track.reduced ;
                                                  string = track : pkgs.writeText "script" ( _utils.strip track.reduced ) ;
                                                } scripts ( fun seed ) ;
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
                                              list = track : builtins.all ( x : x ) track.reduced ;
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
                                        SCRIPT_DIRECTORY=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
                                          cd ${ _utils.bash-variable "SCRIPT_DIRECTORY" } &&
                                          ${ pkgs.nix }/bin/nix flake init &&
                                          ${ pkgs.coreutils }/bin/cp ${ ./src/flake.nix } flake.nix &&
                                          ${ pkgs.coreutils }/bin/echo "${ _utils.bash-variable "1" }" > hook.nix &&
                                          ${ pkgs.coreutils }/bin/echo "${ _utils.bash-variable "2" }" > inputs.nix &&
                                          STRUCTURE_DIRECTORY="${ _utils.bash-variable "3" }" &&
                                          ${ pkgs.coreutils }/bin/echo '${ scripts-expression }' > scripts.nix &&
                                          ${ pkgs.coreutils }/bin/mkdir scripts &&
                                          ${ sed-outer } &&
                                          ${ pkgs.coreutils }/bin/chmod 0400 flake.nix hook.nix inputs.nix scripts.nix &&
                                          ${ pkgs.coreutils }/bin/echo ${ _utils.bash-variable "SCRIPT_DIRECTORY" }
                                      ''
                                    )
                                ] ;
                              shellHook = "${ pkgs.coreutils }/bin/echo HELLO! ${ structure.token }" ;
                            }
                  ) ;
              }
      ) ;
    }
