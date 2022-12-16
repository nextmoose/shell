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
                              lambda = track : track.reduced ( structures.one ( track.reduced structures.zero ) ) ;
                              list = track : track.reduced ;
                              set = track : track.reduced ;
                            } scripts ;
                        _utils = builtins.getAttr system utils.lib ;
                        derivations =
                          _utils.visit
                            {
                              lambda = track :
                                let
                                  numbers = structures.numbers zero ;
                                  variables = structures.variables zero ;
                                  string = track.reduced ( structures.one zero ) ;
                                  zero = track.reduced structures.zero ;
                                  in structures.process-with string numbers variables ;
                              list = track : track.reduced ;
                              set = track : track.reduced ;
                            } scripts ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        structures =
                          let
                            base =
                              {
                                numbers = [ "structure" "logs" "log" "stderr" "temporaries" "temporary" ] ;
                                variables = [ "log" "out" "err" "din" "debug" "notes" "temporary" ] ;
                              } ;
                              delock =
                                ''
                                  if [ ${ _utils.bash-variable "#" } -gt 0 ]
                                  then
                                    DIRECTORY=${ _utils.bash-variable "1" } &&
                                    if [ -d ${ _utils.bash-variable "DIRECTORY" } ]
                                    then
                                      exec 200<>${ _utils.bash-variable "DIRECTORY" }/lock &&
                                      if ${ pkgs.flock }/bin/flock -n -s 200
                                      then
                                        ${ pkgs.coreutils }/bin/rm --force ${ _utils.bash-variable "DIRECTORY" }/lock &&
                                        if [ -z "$( ${ pkgs.findutils }/bin/find ${ _utils.bash-variable "DIRECTORY" } -mindepth 1 )" ]
                                        then
                                          ${ pkgs.coreutils }/bin/rm --recursive --force ${ _utils.bash-variable "DIRECTORY" }
                                        fi &&
                                        shift &&
                                        ${ _utils.bash-variable "0" } ${ _utils.bash-variable "@" }
                                      else
                                        ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ _utils.bash-variable "0" } ${ _utils.bash-variable "@" } | ${ at } now 2> /dev/null
                                      fi
                                    fi
                                  fi
                                '' ;
                           generator =
                              numbers : variables :
                                let
                                  commands =
                                    _utils.visit
                                      {
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        string = track : "${ pkgs.writeShellScriptBin "command" track.reduced }/bin/command" ;
                                      } procedures ;
                                   procedures =
                                    _utils.visit
                                      {
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        string = track : process track.reduced ;
                                      } _scripts ;
                                  in
                                    {
                                      commands = commands ;
                                      logging =
                                        {
                                          query =
                                            target :
                                              let
                                                directory =
                                                  ''
                                                    exec ${ numbers.log }<>${ _utils.bash-variable "1" }/lock &&
                                                    if ${ pkgs.flock }/bin/flock -s -n ${ numbers.log }
                                                    then
                                                      ${ pkgs.coreutils }/bin/cp --recursive ${ _utils.bash-variable "1" } ${ _utils.bash-variable target }
                                                    fi
                                                  '' ;
                                                query =
                                                  ''
                                                    if [ ! -d ${ structure-directory } ]
                                                    then
                                                      ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                    fi &&
                                                    exec ${ numbers.structure }<>${ structure-directory }/lock &&
                                                    ${ pkgs.flock }/bin/flock -s ${ numbers.structure } &&
                                                    if [ ! -d ${ structure-directory }/logs ]
                                                    then
                                                      ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logs
                                                    fi &&
                                                    exec ${ numbers.logs }<>${ structure-directory }/logs/lock &&
                                                    ${ pkgs.flock }/bin/flock -s ${ numbers.logs } &&
                                                    ${ pkgs.findutils }/bin/find \
                                                      ${ structure-directory }/logs \
                                                      -mindepth 1 \
                                                      -maxdepth 1 \
                                                      -type d \
                                                      -exec ${ pkgs.writeShellScriptBin "directory" ( _utils.strip directory ) }/bin/directory {} \;
                                                  '' ;
                                                in _utils.strip query ;
                                        } ;
                                      numbers = numbers ;
                                      pkgs = pkgs ;
                                      variables = variables ;
                                      utils = _utils ;
                                    } ;
                            numbers = string : let r = reducers string ; in builtins.foldl' r.numbers { } base.numbers ;
                            one = string : generator ( numbers string ) ( variables string ) ;
                            process =
                              string :
                                let
                                  n = numbers string ;
                                  v = variables string ;
                                  in process-with string n v ;
                            process-with =
                              string : numbers : variables :
                                let
                                  cleanup =
                                    ''
                                      if [ -d ${ structure-directory } ]
                                      then
                                        exec ${ numbers.structure }<>${ structure-directory }/lock &&
                                        ${ pkgs.flock }/bin/flock -s ${ numbers.structure } &&
                                        if [ -d ${ structure-directory }/logs ]
                                        then
                                          exec ${ numbers.logs }<>${ structure-directory }/logs/lock &&
                                          ${ pkgs.flock }/bin/flock -s ${ numbers.logs } &&
                                          if [ ! -z ${ _utils.bash-variable variables.log } ] && [ -d ${ _utils.bash-variable variables.log } ]
                                          then
                                            exec ${ numbers.log }<>${ _utils.bash-variable variables.log }/lock &&
                                            ${ pkgs.flock }/bin/flock -s ${ numbers.log } &&
                                            ${ pkgs.coreutils }/bin/touch \
                                              ${ _utils.bash-variable variables.log }/out \
                                              ${ _utils.bash-variable variables.log }/err \
                                              ${ _utils.bash-variable variables.log }/din \
                                              ${ _utils.bash-variable variables.log }/debug \
                                              ${ _utils.bash-variable variables.log }/notes &&
                                            ${ pkgs.coreutils }/bin/chmod \
                                              0400 \
                                              ${ _utils.bash-variable variables.log }/out \
                                              ${ _utils.bash-variable variables.log }/err \
                                              ${ _utils.bash-variable variables.log }/din \
                                              ${ _utils.bash-variable variables.log }/debug \
                                              ${ _utils.bash-variable variables.log }/notes
                                          fi
                                        fi &&
                                        if [ -d ${ structure-directory }/temporary ]
                                        then
                                          exec ${ numbers.temporaries }<>${ structure-directory }/temporary/lock &&
                                          ${ pkgs.flock }/bin/flock -s ${ numbers.temporaries } &&
                                          ${ pkgs.findutils }/bin/find ${ _utils.bash-variable variables.temporary } -type f -exec ${ pkgs.coreutils }/bin/shred --force --remove {} \; &&
                                          ${ pkgs.coreutils }/bin/rm --recursive --force ${ _utils.bash-variable variables.temporary }
                                          ${ pkgs.coreutils }/bin/true
                                        fi
                                      fi &&
                                      ${ pkgs.coreutils }/bin/echo \
                                        ${ pkgs.coreutils }/bin/nice \
                                          --adjustment 19 \
                                          ${ pkgs.writeShellScriptBin "delock" delock }/bin/delock \
                                            ${ structure-directory } \
                                            ${ structure-directory }/logs \
                                            ${ _utils.bash-variable variables.log } \
                                              | ${ at } now 2> /dev/null &&
                                      ${ pkgs.coreutils }/bin/echo \
                                        ${ pkgs.coreutils }/bin/nice \
                                          --adjustment 19 \
                                          ${ pkgs.writeShellScriptBin "delock" delock }/bin/delock \
                                            ${ structure-directory } \
                                            ${ structure-directory }/temporary \
                                               | ${ at } now 2> /dev/null
                                    '' ;
                                  temporary =
                                    ''
                                      if [ ! -d ${ structure-directory }/temporary ]
                                      then
                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                      fi &&
                                      exec ${ numbers.temporaries }<>${ structure-directory }/temporary/lock &&
                                      ${ pkgs.flock }/bin/flock -s ${ numbers.temporaries } &&
                                      export ${ variables.temporary }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                      exec ${ numbers.temporary }<>${ _utils.bash-variable variables.temporary }/lock &&
                                      ${ pkgs.flock }/bin/flock -n ${ numbers.temporary }
                                    '' ;
                                  in
                                    ''
                                      cleanup ( )
                                      {
                                        # ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScriptBin "cleanup" ( _utils.strip cleanup ) }/bin/cleanup
                                        ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScriptBin "cleanup" ( _utils.strip cleanup ) }/bin/cleanup | ${ at } now 2> /dev/null
                                      } &&
                                      trap cleanup EXIT &&
                                      if [ ! -d ${ structure-directory } ]
                                      then
                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                      fi &&
                                      exec ${ numbers.structure }<>${ structure-directory }/lock &&
                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure } &&
                                      if [ ! -d ${ structure-directory }/logs ]
                                      then
                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logs
                                      fi &&
                                      exec ${ numbers.logs }<>${ structure-directory }/logs/lock &&
                                      ${ pkgs.flock }/bin/flock -s ${ numbers.logs } &&
                                      export ${ variables.log }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/logs/XXXXXXXX ) &&
                                      exec ${ numbers.log }<>${ _utils.bash-variable variables.log }/lock &&
                                      ${ pkgs.flock }/bin/flock -n ${ numbers.log } &&
                                      ${ if builtins.replaceStrings [ variables.temporary ] [ "" ] string == string then "${ pkgs.coreutils }/bin/true" else _utils.strip temporary } &&
                                      export ${ variables.out }=/dev/stdout &&
                                      export ${ variables.err }=/dev/stderr &&
                                      ${ if builtins.replaceStrings [ variables.din ] [ "" ] string == string then "${ pkgs.coreutils }/bin/true" else "export ${ variables.din }=" } &&
                                      ${ if builtins.replaceStrings [ variables.debug ] [ "" ] string == string then "${ pkgs.coreutils }/bin/true" else "export ${ variables.debug }=1" } &&
                                      ${ if builtins.replaceStrings [ variables.notes ] [ "" ] string == string then "${ pkgs.coreutils }/bin/true" else "export ${ variables.notes }=1" } &&
                                      ${ pkgs.writeShellScriptBin "script" string }/bin/script \
                                        > >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable variables.log }/out 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stdout" ) \
                                        2> >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable variables.log }/err 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stderr" ) &&
                                      if [ ! -z "$( ${ pkgs.coreutils }/bin/cat ${ _utils.bash-variable variables.log }/err )" ]
                                      then
                                        exit ${ numbers.stderr }
                                      fi
                                  '' ;
                            reducers =
                              string :
                                {
                                  numbers =
                                    previous : current :
                                      _utils.try
                                        (
                                          seed :
                                            let
                                              number = builtins.toString seed ;
                                              in
                                                {
                                                  success =
                                                    let
                                                      is-not-duplicate = builtins.all ( p : p != number ) ( builtins.attrValues previous ) ;
                                                      is-not-in-string = builtins.replaceStrings [ number ] [ "" ] string == string ;
                                                      is-not-small = seed > 2 ;
                                                      in is-not-duplicate && is-not-in-string && is-not-small ;
                                                      value = previous // { "${ current }" = number ; } ;
                                                }
                                        ) ;
                                  variables =
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
                                                      is-not-duplicate = builtins.all ( p : p != token ) ( builtins.attrValues previous ) ;
                                                      is-not-in-string = builtins.replaceStrings [ token ] [ "" ] string == string ;
                                                      in is-not-duplicate && is-not-in-string ;
                                                      value = previous // { "${ current }" = token ; } ;
                                                }
                                        ) ;
                                } ;
                            variables = string : let r = reducers string ; in builtins.foldl' r.variables { } base.variables ;
                            zero =
                                let
                                   attrs = src : builtins.listToAttrs ( builtins.map mapper src ) ;
                                   mapper = item : { name = item; value = "" ; } ;
                                   in generator ( attrs base.numbers ) ( attrs base.variables ) ;
                            in
                              {
                                generator = generator ;
                                numbers = numbers ;
                                one = one ;
                                process = process ;
                                process-with = process-with ;
                                variables = variables ;
                                zero = zero ;
                              } ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name value ) ( inputs derivations ) ) ;
                              shellHook = hook _scripts ;
                            }
                  ) ;
              }
      ) ;
    }
