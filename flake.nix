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
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        structure =
                          _utils.try
                            (
                              seed :
                                let
                                  is-not-duplicate =
                                    _utils.visit
                                      {
                                        list = track : builtins.all ( x : x ) track.reduced ;
                                        set = track : builtins.all ( x : x ) ( builtins.attrValues track.reduced ) ;
                                        string =
                                          track :
                                            let
                                              number = builtins.toString seed ;
                                              token = builtins.hashString "sha512" number ;
                                              in builtins.replaceStrings [ number token ] [ "" "" ] track.reduced == track.reduced ;
                                      } ( builtins.getAttr "scripts" ( structure 0 ) ) ;
                                  structure =
                                    seed :
                                      let
                                        _scripts =
                                          _utils.visit
                                            {
                                              lambda = track : track.reduced ( structure seed ) ;
                                              list = track : track.reduced ;
                                              set = track : track.reduced ;
                                            } scripts ;
                                          programs =
                                            _utils.visit
                                              {
                                                list = track : track.reduced ;
                                                set = track : track.reduced ;
                                                string =
                                                  track :
                                                    let
                                                      number = builtins.toString seed ;
                                                      script =
                                                        ''
                                                          cleanup ( )
                                                          {
                                                            if
                                                              [ ! -z ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) } ] &&
                                                              [ -d ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) } ]  &&
                                                              [ -f ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/err ] &&
                                                              [ ! -z "$( ${ pkgs.coreutils }/bin/cat ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/err )" ]
                                                            then
                                                              exit ${ number }
                                                            fi &&
                                                            ( ${ pkgs.coreutils }/bin/cat <<EOF
                                                          ${ pkgs.coreutils }/bin/chmod \
                                                            0400 \
                                                            ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/out \
                                                            ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/err &&
                                                            ${ pkgs.findutils }/bin/find ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/temporary -type f -exec ${ pkgs.coreutils }/bin/shred --force --release {} \; &&
                                                            ${ pkgs.coreutils }/bin/rm --recursive --force ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/temporary
                                                          EOF
                                                            ) | ${ at } now 2> /dev/null
                                                          } &&
                                                          trap cleanup EXIT &&
                                                          if [ ! -d ${ structure-directory } ]
                                                          then
                                                            ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                          fi &&
                                                          if [ ! -d ${ structure-directory }/logs ]
                                                          then
                                                            ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logs
                                                          fi &&
                                                          ${ builtins.concatStringsSep "_" [ "LOG" token ] }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/logs/XXXXXXXX ) &&
                                                          exec ${ number }<>${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/lock &&
                                                          ${ pkgs.flock }/bin/flock -n ${ number } &&
                                                          ${ if builtins.replaceStrings [ ( _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) ) ] [ ] track.reduced == track.reduced then "${ pkgs.coreutils }/bin/mkdir ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/temporary" else "${ pkgs.coreutils }/bin/true" } &&
                                                          ${ pkgs.writeShellScriptBin "script" ( _utils.strip track.reduced ) }/bin/script > >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/out 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stdout" ) 2> >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/err 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stderr" )
                                                        '' ;
                                                      token = builtins.hashString "sha512" number ;
                                                      in builtins.toString ( pkgs.writeShellScriptBin "script" script ) ;
                                                } _scripts ;
                                          in
                                            {
                                              commands =
                                                _utils.visit
                                                  {
                                                    list = track : track.reduced ;
                                                    set = track : track.reduced ;
                                                    string = track : "${ track.reduced }/bin/script" ;
                                                  } programs ;
                                              pkgs = pkgs ;
                                              programs = programs ;
                                              scripts = _scripts ;
                                              urandom = urandom ;
                                            } ;
                                  in
                                    {
                                      success = seed > 2 && is-not-duplicate ;
                                      value = structure seed ;
                                    }
                            ) ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name ( builtins.readFile value ) ) ( inputs structure.commands ) ) ;
                              shellHook = hook structure.scripts ;
                            }
                  ) ;
              }
      ) ;
    }
