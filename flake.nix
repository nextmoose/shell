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
                                  _scripts =
                                    _utils.visit
                                      {
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        string = track : _utils.strip track.reduced ;
                                        undefined = track : builtins.throw "517fa195-01d0-47e3-8998-2d05ff2f95e7" ;
                                      } ( scripts structure ) ;
                                  programs =
                                    _utils.visit
                                      {
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        string =
                                          track :
                                            let
                                              cleanup =
                                                ''
                                                  [ -d ${ structure-directory } ] &&
                                                  exec ${ numbers.script.structure }<>${ structure-directory }/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.structure } &&
                                                  [ -d ${ structure-directory }/logs ] &&
                                                  exec ${ numbers.script.logs }<>${ structure-directory }/logs/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.logs } &&
                                                  [ -d ${ _utils.bash-variable variables.script.log } ] &&
                                                  exec ${ numbers.script.log }<>${ _utils.bash-variable variables.script.log }/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.log } &&
                                                  ${ pkgs.coreutils }/bin/touch \
                                                    ${ _utils.bash-variable variables.script.log }/out \
                                                    ${ _utils.bash-variable variables.script.log }/err \
                                                    ${ _utils.bash-variable variables.script.log }/din \
                                                    ${ _utils.bash-variable variables.script.log }/debug \
                                                    ${ _utils.bash-variable variables.script.log }/notes
                                                  ${ pkgs.coreutils }/bin/chmod \
                                                    0400 \
                                                    ${ _utils.bash-variable variables.script.log }/out \
                                                    ${ _utils.bash-variable variables.script.log }/err \
                                                    ${ _utils.bash-variable variables.script.log }/din \
                                                    ${ _utils.bash-variable variables.script.log }/debug \
                                                    ${ _utils.bash-variable variables.script.log }/notes &&
                                                  [ -d ${ structure-directory }/temporary ] &&
                                                  exec ${ numbers.script.temporaries }<>${ structure-directory }/temporary/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.temporaries } &&
                                                  [ -d ${ _utils.bash-variable variables.shared.temporary } ]
                                                  exec ${ numbers.script.temporary }<>${ _utils.bash-variable variables.shared.temporary }/lock &&
                                                  ${ pkgs.flock }/bin/flock ${ numbers.script.temporary } &&
                                                  ${ pkgs.findutils }/bin/find ${ _utils.bash-variable variables.shared.temporary } -type f -exec ${ pkgs.coreutils }/shred --force --remove {} \; &&
                                                  ${ pkgs.coreutils }/bin/rm --recursive ${ _utils.bash-variable variables.shared.temporary } &&
                                                  ${ unlock } ${ structure-directory } ${ structure-directory }/logs ${ _utils.bash-variable variables.script.log } &&
                                                  ${ unlock } ${ structure-directory } ${ structure-directory }/temporary
                                                '' ;
                                              process =
                                                ''
                                                  export ${ variables.script.process }=${ _utils.bash-variable "!" }
                                                '' ;
                                              program =
                                                ''
                                                  ${ variables.script.cleanup } ( )
                                                  {
                                                    ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScriptBin "cleanup" ( _utils.strip cleanup ) }/bin/cleanup |
                                                      ${ at } now 2> /dev/null
                                                  } &&
                                                  trap ${ variables.script.cleanup } EXIT &&
                                                  if [ ! -d ${ structure-directory } ]
                                                  then
                                                    ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                  fi &&
                                                  exec ${ numbers.script.structure }<>${ structure-directory }/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.structure } &&
                                                  if [ ! -d ${ structure-directory }/logs ]
                                                  then
                                                    ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logs
                                                  fi &&
                                                  exec ${ numbers.script.logs }<>${structure-directory }/logs/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.logs } &&
                                                  export ${ variables.script.log }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/logs/XXXXXXXX ) &&
                                                  exec ${ numbers.script.log }<>${ _utils.bash-variable variables.script.log }/lock &&
                                                  ${ pkgs.flock }/bin/flock ${ numbers.script.log } &&
                                                  ${ _utils.strip process } &&
                                                  ${ _utils.strip temporary } &&
                                                  ${ pkgs.writeShellScriptBin "script" ( _utils.strip track.reduced ) }/bin/script "${ _utils.bash-variable "@" }" \
                                                    > >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable variables.script.log }/out 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stdout" ) \
                                                    2> >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable variables.script.log }/err 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stderr" ) &&
                                                  if [ ! -z "$( ${ pkgs.coreutils }/bin/cat ${ _utils.bash-variable variables.script.log }/err )" ]
                                                  then
                                                    exit ${ numbers.script.err }
                                                  fi
                                                '' ;
                                              temporary =
                                                if builtins.replaceStrings [ variables.shared.temporary ] [ "" ] track.reduced == track.reduced then "# temporary directory"
                                                else
                                                  ''
                                                    if [ ! -d ${ structure-directory }/temporary ]
                                                    then
                                                      ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                                    fi &&
                                                    exec ${ numbers.script.temporaries }<>${ structure-directory }/temporary/lock &&
                                                    ${ pkgs.flock }/bin/flock -s ${ numbers.script.temporaries } &&
                                                    export ${ variables.shared.temporary }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                                    exec ${ numbers.script.temporary }<>${ _utils.bash-variable variables.shared.temporary }/lock &&
                                                    ${ pkgs.flock }/bin/flock ${ numbers.script.temporary }
                                                 '' ;
                                              in _utils.strip program ;
                                        undefined = track : builtins.throw "0b2d765f-efb2-40c5-a4a2-346af4703a6d" ;
                                      } _scripts ;
                                  structure =
                                    {
                                      commands =
                                        _utils.visit
                                          {
                                            list = track : track.reduced ;
                                            set = track : track.reduced ;
                                            string = track : "${ pkgs.writeShellScriptBin "command" ( _utils.strip track.reduced ) }/bin/command" ;
                                            undefined = track : builtins.throw "9d8e3fa4-9e9a-4553-8b4f-296023def4c4" ;
                                          } programs ;
                                      loggers =
                                        let
                                          mapper =
                                            name :
                                              {
                                                name = name ;
                                                value =
                                                  _utils.strip
                                                    ''
                                                      >( ${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable variables.script.log }/${ name } 2> /dev/null )
                                                    '' ;
                                              } ;
                                          in builtins.listToAttrs ( builtins.map mapper [ "din" "debug" "notes" ] ) ;
                                      logging =
                                        {
                                          delete =
                                            let
                                              delete =
                                                ''
                                                  ${ variables.script.cleanup } ( )
                                                  {
                                                    if [ ${ _utils.bash-variable "?" } == 0 ]
                                                    then
                                                      ${ pkgs.coreutils }/bin/echo ${ _utils.bash-variable "LOG" }
                                                    else
                                                      ${ pkgs.coreutils }/bin/echo ${ _utils.bash-variable "LOG" } > /dev/stderr
                                                    fi
                                                  } &&
                                                  trap ${ variables.script.cleanup } EXIT &&
                                                  LOG=${ _utils.bash-variable "1" } &&
                                                  [ -d ${ structure-directory } ] &&
                                                  exec ${ numbers.script.structure }<>${ structure-directory }/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.structure } &&
                                                  [ -d ${ structure-directory }/logs ] &&
                                                  exec ${ numbers.script.logs }<>${ structure-directory }/logs/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.log } &&
                                                  [ -d ${ structure-directory }/logs/${ _utils.bash-variable "1" } ] &&
                                                  exec ${ numbers.script.log }<>${ structure-directory }/logs/${ _utils.bash-variable "LOG" }/lock &&
                                                  ${ pkgs.flock }/bin/flock ${ numbers.script.log } &&
                                                  ${ pkgs.findutils }/bin/find ${ structure-directory }/logs/${ _utils.bash-variable "LOG" } -type f -exec ${ pkgs.coreutils }/bin/shred --force --remove {} \; &&
                                                  ${ pkgs.coreutils }/bin/rm --recursive ${ structure-directory }/logs/${ _utils.bash-variable "LOG" }
                                                '' ;
                                              in "${ pkgs.writeShellScriptBin "delete" ( _utils.strip delete ) }/bin/delete" ;
                                          query =
                                            let
                                              directory =
                                                ''
                                                  ${ variables.script.cleanup } ( )
                                                  {
                                                    if [ ${ _utils.bash-variable "?" } == 0 ] && [ ${ _utils.bash-variable "SOURCE" } != ${ _utils.bash-variable variables.script.log } ]
                                                    then
                                                      ${ pkgs.coreutils }/bin/basename ${ _utils.bash-variable "SOURCE" }
                                                    elif [ ${ _utils.bash-variable "SOURCE" } != ${ _utils.bash-variable variables.script.log } ]
                                                    then
                                                      ${ pkgs.coreutils }/bin/basename ${ _utils.bash-variable "SOURCE" } > /dev/stderr
                                                    fi
                                                  } &&
                                                  trap ${ variables.script.cleanup } EXIT &&
                                                  SOURCE=${ _utils.bash-variable "1" } &&
                                                  TARGET=${ _utils.bash-variable "2" } &&
                                                  if [ ${ _utils.bash-variable "SOURCE" } != ${ _utils.bash-variable variables.script.log } ]
                                                  then
                                                    [ -d ${ _utils.bash-variable "SOURCE" } ] &&
                                                    exec ${ numbers.script.log }<>${ _utils.bash-variable "SOURCE" }/lock &&
                                                    ${ pkgs.flock }/bin/flock -sn ${ numbers.script.log } &&
                                                    ${ pkgs.coreutils }/bin/cp --recursive ${ _utils.bash-variable "SOURCE" } ${ _utils.bash-variable "TARGET" }
                                                  fi
                                                '' ;
                                              query =
                                                ''
                                                  [ -d ${ structure-directory } ] &&
                                                  exec ${ numbers.script.structure }<>${ structure-directory }/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.structure } &&
                                                  [ -d ${ structure-directory }/logs ] &&
                                                  exec ${ numbers.script.logs }<>${ structure-directory }/logs/lock &&
                                                  ${ pkgs.flock }/bin/flock -s ${ numbers.script.logs } &&
                                                  ${ pkgs.findutils }/bin/find ${ structure-directory }/logs -mindepth 1 -maxdepth 1 -type d -exec ${ pkgs.writeShellScriptBin "directory" ( _utils.strip directory ) }/bin/directory {} ${ _utils.bash-variable "1" } \;
                                                '' ;
                                              in "${ pkgs.writeShellScriptBin "query" ( _utils.strip query ) }/bin/query" ;
                                        } ;
                                      numbers = numbers.shared ;
                                      pkgs = pkgs ;
                                      resources = _utils.visit
                                        {
                                          lambda = track : "${ pkgs.coreutils }/bin/echo PLACE HOLDER RESOURCES" ;
                                          list = track : track.reduced ;
                                          set = track : track.reduced ;
                                          undefined = track : builtins.throw "2b30d5ba-319f-475e-b502-38f15537a0d0" ;
                                        } ( resources _scripts ) ;
                                      urandom = urandom ;
                                      utils = _utils ;
                                      variables = variables.shared ;
                                    } ;
                                  unlock =
                                    let
                                      asynch =
                                        ''
                                          ${ pkgs.writeShellScriptBin "asynch" "${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ _utils.strip synch }" "${ _utils.bash-variable "@" }" }/bin/asynch"
                                        '' ;
                                      script =
                                        ''
                                          if [ ${ _utils.bash-variable "#" } -gt 0 ]
                                          then
                                            [ -d ${ _utils.bash-variable "1" } ] &&
                                            exec 200<>${ _utils.bash-variable "1" }/lock &&
                                            if [ ${ _utils.bash-variable "#" } == 1 ]
                                            then
                                              if ${ pkgs.flock }/bin/flock 200
                                              then
                                                ${ pkgs.coreutils }/bin/rm ${ _utils.bash-variable "1" }/lock
                                              else
                                                ${ _utils.strip asynch } "${ _utils.bash-variable "@" }"
                                              fi
                                            else
                                              if ${ pkgs.flock }/bin/flock -s 200
                                              then
                                                shift &&
                                                ${ _utils.strip synch } "${ _utils.bash-variable "@" }"
                                              else
                                                ${ _utils.strip asynch } "${ _utils.bash-variable "@" }"
                                              fi
                                            fi
                                          fi
                                        '' ;
                                        synch =
                                          ''
                                            ${ pkgs.writeShellScriptBin "synch" ( _utils.strip script ) }/bin/synch "${ _utils.bash-variable "@" }"
                                          '' ;
                                      in _utils.strip asynch ;
                                  in
                                    {
                                      hook = hook _scripts ;
                                      inputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name ( _utils.strip value ) ) ( inputs programs ) ) ;
                                      scripts = _scripts ;
                                    } ;
                            zero =
                              let
                                numbers =
                                  let
                                    indexed =
                                      _utils.visit
                                        {
                                          list = track : builtins.concatLists track.reduced ;
                                          set = track : builtins.concatLists ( builtins.attrValues track.reduced ) ;
                                          string = track : [ ( track.reduced ) ] ;
                                          undefined = track : builtins.throw "fd3b0b59-3496-4e11-871a-676c5ce2d59c" ;
                                        } raw.numbers ;
                                    seeded =
                                      let
                                        reducer =
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
                                                            is-big = seed > 2 ;
                                                            is-not-in-zero =
                                                              _utils.visit
                                                                {
                                                                  list = track : builtins.all ( x : x ) track.reduced ;
                                                                  set = track : builtins.all ( x : x ) ( builtins.attrValues track.reduced ) ;
                                                                  string = track : builtins.replaceStrings [ number ] [ "" ] track.reduced == track.reduced ;
                                                                  undefined = track : builtins.throw "6bcee02a-7b11-49c3-84c9-94dcede4c27e" ;
                                                                } zero.scripts ;
                                                            is-unique = builtins.all ( p : p != number ) previous ;
                                                            in is-big && is-not-in-zero && is-unique ;
                                                        value = builtins.concatLists [ previous [ number ] ] ;
                                                      }
                                              ) ;
                                        in builtins.foldl' reducer [ ] indexed ;
                                    in
                                      _utils.visit
                                        {
                                          list = track : builtins.trace "XXXX LIST ${ builtins.toString track.index } ${ builtins.toString track.size }" builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                          set = track : builtins.trace "XXXX SET ${ builtins.toString track.index } ${ builtins.toString track.size }" track.reduced ;
                                          string = track : builtins.trace "XXXX STRING ${ builtins.toString track.index } ${ builtins.toString track.size } \"${ track.reduced }\"" { "${ track.reduced }" = builtins.trace ( "YES ${ builtins.toString track.index }" ) ( builtins.elemAt seeded track.index ) ; } ;
                                          undefined = track : builtins.trace "XXXX UNDEFINED ${ builtins.toString track.index } ${ builtins.toString track.size } ${ builtins.typeOf track.reduced }" ( builtins.throw "17080e4a-4ff0-4de2-a3aa-688569801eee" ) ;
                                        } raw.numbers ;
                                raw =
                                  {
                                    numbers =
                                      {
                                        script = [ "structure" "logs" "log" "temporaries" "temporary" "err" ] ;
                                      } ;
                                    variables =
                                      {
                                        script = [ "cleanup" "log" "process" "time" ] ;
                                        shared = [ "temporary" ] ;
                                      } ;
                                  } ;
                                variables =
                                  let
                                    indexed =
                                      _utils.visit
                                        {
                                          list = track : builtins.concatLists track.reduced ;
                                          set = track : builtins.concatLists ( builtins.attrValues track.reduced ) ;
                                          string = track : [ ( track.reduced ) ] ;
                                          undefined = track : builtins.throw "bc11109e-0657-4a91-8ae5-655cbcf14dbd" ;
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
                                                                  undefined = track : builtins.throw "cbff9956-79af-46be-b16d-54d46dece78c" ;
                                                                } zero.scripts ;
                                                            is-unique = builtins.all ( p : p != token ) previous ;
                                                            in is-not-in-zero && is-unique ;
                                                        value = builtins.concatLists [ previous [ token ] ] ;
                                                      }
                                              ) ;
                                        in builtins.foldl' reducer [ ] indexed ;
                                    in
                                      _utils.visit
                                        {
                                          list = track : builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                          set = track : track.reduced ;  
                                          string = track : { "${ track.reduced }" = builtins.elemAt seeded track.index ; } ;
                                          undefined = track : builtins.throw "060de9e8-be75-4be5-aed5-4fe41fda9e11" ;
                                        } raw.variables ;
                                zero =
                                  let
                                    processed =
                                      _utils.visit
                                        {
                                          list = track : builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                          set = track : track.reduced ;
                                          string = track : { "${ _utils.strip track.reduced }" = "" ; } ;
                                          undefined = track : builtins.throw "7a282524-34ba-4ae7-b026-6fbd78716180" ;
                                        } raw ;
                                    in fun processed.numbers processed.variables ;
                                in fun numbers variables ;
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
