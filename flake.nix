  {
    inputs = { flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ; } ;
    outputs =
      { flake-utils , self } :
        (
          {
            lib =
              nixpkgs : flakes : at : structure-directory : scripts : resources : hook : inputs :
                flake-utils.lib.eachDefaultSystem
                  (
                    system :
                      {
                        devShell =
                          let
                            _flakes = builtins.mapAttrs ( name : value : builtins.getAttr "lib" value ) flakes ;
                            _scripts =
                              target :
                                let
                                  lambda =
                                    track :
                                      let
                                        arguments = [ "temporary-dir" "logging-dir" "trap" ] ;
                                        command = pkgs.writeShellScript "command" input ;
                                        date-format = "%Y-%m-%d-%H-%M-%S" ;
                                        debug =
                                          {
                                            delock-structure-directory =
                                              {
                                                delock-logging-directory = 0 ;
                                                delock-resources-directory = 0 ;
                                                delock-temporary-directory = 0 ;
                                              } ;
                                          } ;
                                        delock-structure-directory =
                                          ''
                                            if [ -d ${ structure-directory } ]
                                            then
                                              exec 201<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock 201 &&
                                              ${ pkgs.coreutils }/bin/rm ${ structure-directory }/lock &&
                                              ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ structure-directory }
                                            fi
                                          '' ;

                                        hook = track.reduced ( structure locals ) ;
                                        identity = x : x ;
                                        input =
                                          let
                                            delete-temporary-dir =
                                              ''
                                                if [ -d ${ bash-variable locals.temporary-dir } ]
                                                then
                                                 exec 201<>${ structure-directory }/lock &&
                                                  ${ pkgs.flock }/bin/flock -s 201 &&
                                                  if [ -d ${ bash-variable locals.temporary-dir } ]
                                                  then
                                                    exec 202<>${ structure-directory }/temporary/lock &&
                                                    ${ pkgs.flock }/bin/flock -s 202 &&
                                                    if [ -d ${ bash-variable locals.temporary-dir } ]
                                                    then
                                                      exec 203<>${ bash-variable locals.temporary-dir }/lock &&
                                                      ${ pkgs.flock }/bin/flock 203 &&
                                                      ${ pkgs.findutils }/bin/find ${ bash-variable locals.temporary-dir } -type f -exec ${ pkgs.coreutils }/bin/shred --remove {} \; &&
                                                      ${ pkgs.coreutils }/bin/rm --recursive --force ${ bash-variable locals.temporary-dir }
                                                     fi
                                                  fi
                                                fi &&
                                                ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delock-temporary-directory" ( strip delock-temporary-directory ) } | ${ at } now
                                              '' ;
                                            delock-logging-dir =
                                              ''
                                                if [ -d ${ bash-variable locals.logging-dir } ]
                                                then
                                                  exec 201<>${ structure-directory }/lock &&
                                                  ${ pkgs.flock }/bin/flock -s 201 &&
                                                  if [ -d ${ bash-variable locals.logging-dir } ]
                                                  then
                                                    exec 202<>${ structure-directory }/logging/lock &&
                                                    ${ pkgs.flock }/bin/flock -s 202 &&
                                                    if [ -d ${ bash-variable locals.logging-dir } ]
                                                    then
                                                      exec 203<>${ bash-variable locals.logging-dir }/lock &&
                                                      ${ pkgs.flock }/bin/flock 203 &&
                                                      ${ pkgs.coreutils }/bin/touch ${ bash-variable locals.logging-dir }/out &&
                                                      ${ pkgs.coreutils }/bin/touch ${ bash-variable locals.logging-dir }/err &&
                                                      ${ pkgs.coreutils }/bin/chmod 0400 ${ bash-variable locals.logging-dir }/out &&
                                                      ${ pkgs.coreutils }/bin/chmod 0400 ${ bash-variable locals.logging-dir }/err &&
                                                      ${ pkgs.coreutils }/bin/chmod 0400 ${ bash-variable locals.logging-dir }/time &&
                                                      ${ pkgs.findutils }/bin/find ${ bash-variable locals.logging-dir } -type f -name '*.*' -exec ${ pkgs.coreutils }/bin/chmod 0400 {} \;
                                                      ${ pkgs.coreutils }/bin/rm ${ bash-variable locals.logging-dir }/lock &&
                                                      ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ bash-variable locals.logging-dir }
                                                    fi
                                                  fi
                                                fi &&
                                                ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delock-logging-directory" ( strip delock-logging-directory ) } | ${ at } now
                                              '' ;
                                            delock-logging-directory =
                                              ''
                                                if [ -d ${ structure-directory }/logging ]
                                                then
                                                  exec 201<>${ structure-directory }/lock &&
                                                  ${ pkgs.flock }/bin/flock -s 2-1 &&
                                                  if [ -d ${ structure-directory }/logging ]
                                                  then
                                                    exec 202<>${ structure-directory }/logging/lock &&
                                                    ${ pkgs.flock }/bin/flock 202 &&
                                                    ${ pkgs.coreutils }/bin/rm ${ structure-directory }/logging/lock &&
                                                    ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ structure-directory }/logging
                                                  fi
                                                fi
                                                ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delock-structure-directory" ( strip delock-structure-directory ) } | ${ at } now + ${ builtins.toString debug.delock-structure-directory.delock-logging-directory } min
                                              '' ;
                                            delock-temporary-directory =
                                              ''
                                                if [ -d ${ structure-directory }/temporary ]
                                                then
                                                  exec 201<>${ structure-directory }/lock &&
                                                  ${ pkgs.flock }/bin/flock -s 201 &&
                                                  if [ -d ${ structure-directory }/temporary ]
                                                  then
                                                    exec 202<>${ structure-directory }/temporary/lock &&
                                                    ${ pkgs.flock }/bin/flock 202 &&
                                                    ${ pkgs.coreutils }/bin/rm ${ structure-directory }/temporary/lock &&
                                                    ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ structure-directory }/temporary
                                                  fi
                                                fi &&
                                                ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delock-structure-directory" ( strip delock-structure-directory ) } | ${ at } now + ${ builtins.toString debug.delock-structure-directory.delock-temporary-directory } min
                                              '' ;
                                            temporary = if contains hook ( locals.temporary-dir ) then "" else "# " ;
                                            program = pkgs.writeShellScript "hook" ( strip hook ) ;
                                            standard =
                                              output :
                                                let
                                                  process =
                                                    ''
                                                      >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts ${ date-format } > ${ bash-variable locals.logging-dir }/${ output } 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/std${ output }" )
                                                    '' ;
                                                  in strip process ;
                                            time-format =
                                              let
                                                base = "xDEFIKMOPRSUWXZcekprstwC" ;
                                                generator = index : builtins.concatStringsSep "" [ "%" ( builtins.substring index 1 base ) "\\n" ] ;
                                                length = builtins.stringLength base ;
                                                list = builtins.genList generator length ;
                                                in builtins.concatStringsSep "" list ;
                                            in
                                              ''
                                                if [ ! -d ${ structure-directory } ]
                                                then
                                                  ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                fi &&
                                                exec 201<>${ structure-directory }/lock &&
                                                ${ pkgs.flock }/bin/flock -s 201 &&
                                                ${temporary }if [ ! -d ${ structure-directory }/temporary ]
                                                ${temporary }then
                                                ${temporary }  ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                                ${temporary }fi &&
                                                ${temporary }exec 202<>${ structure-directory }/temporary/lock &&
                                                ${temporary }${ pkgs.flock }/bin/flock -s 202 &&
                                                ${temporary }export ${ locals.temporary-dir }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                                ${temporary }exec 203<>${ bash-variable locals.temporary-dir }/lock &&
                                                ${temporary }${ pkgs.flock }/bin/flock 203 &&
                                                if [ ! -d ${ structure-directory }/logging ]
                                                then
                                                  ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logging
                                                fi &&
                                                exec 204<>${ structure-directory }/logging/lock &&
                                                ${ pkgs.flock }/bin/flock -s 204 &&
                                                export ${ locals.logging-dir }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/logging/XXXXXXXX ) &&
                                                exec 205<>${ bash-variable locals.logging-dir }/lock &&
                                                ${ pkgs.flock }/bin/flock 205 &&
                                                cleanup ( )
                                                {
                                                  ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delock-logging-dir" ( strip delock-logging-dir ) } | ${ at } now 2> /dev/null &&
                                                  ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delete-temporary-dir" ( strip delete-temporary-dir ) } | ${ at } now 2> /dev/null &&
                                                  if [ -f ${ bash-variable locals.logging-dir }/time ] && [ ! -s ${ bash-variable locals.logging-dir }/err ]
                                                  then
                                                    exit $( ${ pkgs.coreutils }/bin/head --lines 1 ${ bash-variable locals.logging-dir }/time )
                                                  elif [ -f ${ bash-variable locals.logging-dir }/time ]
                                                  then
                                                    exit 64
                                                  elif [ ! -s ${ bash-variable locals.logging-dir }/err ]
                                                  then
                                                    exit 65
                                                  else
                                                    exit 66
                                                  fi
                                                } &&
                                                trap cleanup EXIT
                                                ${ pkgs.time }/bin/time --format "${ time-format }" --output ${ bash-variable locals.logging-dir }/time ${ program } "${ bash-variable "@" }" \
                                                  > ${ standard "out" } \
                                                  2> ${ standard "err" }
                                              '' ;
                                        locals = variable arguments tokenizer false ;
                                        string =
                                          let
                                            locals = variable arguments builtins.toString true ;
                                            in track.reduced ( structure locals ) ;
                                        structure =
                                          locals :
                                            let
                                              in
                                                {
                                                  commands = _scripts "command" ;
                                                  flakes = _flakes ;
                                                  logger =
                                                    name :
                                                      ">( ${ pkgs.moreutils }/bin/ts ${ date-format } > $( ${ pkgs.coreutils }/bin/mktemp --suffix .${ builtins.hashString "sha512" ( builtins.toString name ) }.log ${ bash-variable locals.logging-dir }/XXXXXXXX ) 2> /dev/null )" ;
                                                  logs =
                                                    pkgs.writeShellScript
                                                      "logs"
                                                      (
                                                        let
                                                          log =
                                                            pkgs.writeShellScript
                                                              "log"
                                                              ''
                                                                exec 201<>${ bash-variable "1" }/lock &&
                                                                ${ pkgs.flock }/bin/flock -n 201 &&
                                                                if [ -f ${ bash-variable "1" }/out ] && [ $( ${ pkgs.coreutils }/bin/stat --format "%a" ${ bash-variable "1" }/out ) -eq 0400 ]
                                                                then
                                                                  ${ pkgs.coreutils }/bin/mv ${ bash-variable "1" } ${ bash-variable locals.temporary-dir }
                                                                fi
                                                              '' ;
                                                          in
                                                            ''
                                                              ${ pkgs.findutils }/bin/find ${ structure-directory }/logging -mindepth 1 -maxdepth 1 -type d -exec ${ log } {} \;
                                                            ''
                                                      ) ;
                                                  pkgs = pkgs ;
                                                  resources =
                                                    let
                                                      lambda =
                                                        track :
                                                          let
                                                            fun =
                                                              salt :
                                                                let
                                                                  bool = track : unsalted track.reduced ;
                                                                  int = track : salted track.reduced ;
                                                                  null = track : salted track.reduced ;
                                                                  undefined = track : track.throw "f79788be-8944-43ac-bf58-5a816009b5f3" ;
                                                                  in visit { bool = bool ; int = int ; null = null ; undefined = undefined ; } salt ;
                                                            salted =
                                                              salt : init : release : show :
                                                                let
                                                                  _init =
                                                                    let
                                                                      bool =
                                                                        track :
                                                                          if track.reduced then "${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resources/${ bash-variable "SALT" }/resource"
                                                                          else "${ pkgs.coreutils }/bin/true" ;
                                                                      lambda =
                                                                        track :
                                                                          let
                                                                            mkdir = if contains ( track.reduced ( _scripts "hook" ) ) ( bash-variable 1 ) then "# " else "" ;
                                                                            script = track.reduced ( _scripts "command" ) ;
                                                                            in
                                                                              ''
                                                                                ${ mkdir }${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resources/${ bash-variable "SALT" }/resource &&
                                                                                ${ mkdir }cd ${ structure-directory }/resources/${ bash-variable "SALT" }/resource &&
                                                                                ${ script } ${ structure-directory }/resources/${ bash-variable "SALT" }/resource
                                                                              '' ;
                                                                      null = track : "${ pkgs.coreutils }/bin/true" ;
                                                                      undefined = track : track.throw "ab341084-29c7-4404-a60a-deaca66c6e4f" ;
                                                                      in visit { bool = bool ; lambda = lambda ; null = null ; undefined = undefined ; } init ;
                                                                  _release =
                                                                    let
                                                                      lambda = track : track.reduced ( _scripts "command" ) ;
                                                                      null = track : "${ pkgs.coreutils }/bin/true" ;
                                                                      undefined = track : track.throw "0d2d96a3-4ada-405c-a919-9837bd701cc1" ;
                                                                      in visit { lambda = lambda ; null = null ; undefined = undefined ; } release ;
                                                                  _salt =
                                                                    let
                                                                      int = track : "$(( ${ bash-variable "TIMESTAMP" } / ${ builtins.toString track.reduced } ))" ;
                                                                      lambda = track : "$( ${ track.reduced ( _scripts "command" ) } ${ bash-variable "TIMESTAMP" } )" ;
                                                                      null = track : "$(( ${ bash-variable "TIMESTAMP" } / ( 60 * 60 ) ))" ;
                                                                      undefined = track : track.throw "547148a4-88ff-4eb9-aaa4-1703b46e5a6c" ;
                                                                      in visit { int = int ; lambda = lambda ; null = null ; undefined = undefined ; } salt ;
                                                                  delock-resources-directory =
                                                                    ''
                                                                      if [ -d ${ structure-directory }/resources ]
                                                                      then
                                                                        exec 201<>${ structure-directory }/lock &&
                                                                        ${ pkgs.flock }/bin/flock -s 201 &&
                                                                        if [ -d ${ structure-directory }/resources ]
                                                                        then
                                                                          exec 202<>${ structure-directory }/resources/lock &&
                                                                          ${ pkgs.flock }/bin/flock 202 &&
                                                                          ${ pkgs.coreutils }/bin/rm ${ structure-directory }/resources/lock &&
                                                                          ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ structure-directory }/resources
                                                                        fi
                                                                      fi &&
                                                                      ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delock-structure-directory" ( strip delock-structure-directory ) } | ${ at } now + ${ builtins.toString debug.delock-structure-directory.delock-resources-directory } min
                                                                    '' ;
                                                                  delock-resources-dir =
                                                                    ''
                                                                      if [ -d ${ structure-directory }/resources/${ bash-variable 1 } ]
                                                                      then
                                                                        exec 201<>${ structure-directory }/lock &&
                                                                        ${ pkgs.flock }/bin/flock -s 201 &&
                                                                        if [ -d ${ structure-directory }/resources/${ bash-variable 1 } ]
                                                                        then
                                                                          exec 202<>${ structure-directory }/resources/lock &&
                                                                          ${ pkgs.flock }/bin/flock -s 202 &&
                                                                          if [ -d ${ structure-directory }/resources/${ bash-variable 1 } ]
                                                                          then
                                                                            exec 203<>${ structure-directory }/resources/${ bash-variable 1 }/lock &&
                                                                            ${ pkgs.flock }/bin/flock 203 &&
                                                                            ${ pkgs.coreutils }/bin/rm ${ structure-directory }/resources/${ bash-variable 1 }/lock &&
                                                                            ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ structure-directory }/resources/${ bash-variable 1 } &&
                                                                            ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delock-resources-directory" ( strip delock-resources-directory ) } | ${ at } now
                                                                          fi
                                                                        fi
                                                                      fi &&
                                                                      ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "destroy-resources-dir" ( strip destroy-resources-dir ) } ${ bash-variable 1 } | ${ at } now + 1 min
                                                                    '' ;
                                                                  destroy-resources-dir =
                                                                    ''
                                                                      OLD_SALT=${ bash-variable 1 } &&
                                                                      TIMESTAMP=$( ${ pkgs.coreutils }/bin/date +%s ) &&
                                                                      NEW_SALT=$( ${ pkgs.coreutils }/bin/echo ${ pre-salt } ${ _salt } | ${ pkgs.coreutils }/bin/md5sum | ${ pkgs.coreutils }/bin/cut --bytes -32 ) &&
                                                                       if [ -d ${ structure-directory }/resources/${ bash-variable "OLD_SALT" } ] &&  [ ${ bash-variable "OLD_SALT" } != ${ bash-variable "NEW_SALT" } ]
                                                                      then
                                                                        exec 201<>${ structure-directory }/lock &&
                                                                        ${ pkgs.flock }/bin/flock -s 201 &&
                                                                        if [ -d ${ structure-directory }/resources/${ bash-variable "OLD_SALT" } ] &&  [ ${ bash-variable "OLD_SALT" } != ${ bash-variable "NEW_SALT" } ]
                                                                        then
                                                                          exec 202<>${ structure-directory }/resources/lock &&
                                                                          ${ pkgs.flock }/bin/flock -s 202 &&
                                                                          if [ -d ${ structure-directory }/resources/${ bash-variable "OLD_SALT" } ] &&  [ ${ bash-variable "OLD_SALT" } != ${ bash-variable "NEW_SALT" } ]
                                                                          then
                                                                            exec 203<>${ structure-directory }/resources/${ bash-variable "OLD_SALT" }/lock &&
                                                                            ${ pkgs.flock }/bin/flock 203 &&
                                                                            ${ pkgs.findutils }/bin/find ${ structure-directory }/resources/${ bash-variable "OLD_SALT" } -name '*.pid' | while read PID_FILE
                                                                            do
    								              ${ pkgs.coreutils }/bin/echo debug 9 ${ bash-variable "PID_FILE" } >> debug &&								    
                                                                              ${ pkgs.coreutils }/bin/tail --pid $( ${ pkgs.coreutils }/bin/cat ${ bash-variable "PID_FILE" } ) --follow /dev/null &&
									      ${ pkgs.coreutils }/bin/rm ${ bash-variable "PID_FILE" }
                                                                            done &&
                                                                            ${ _release } &&
                                                                            ${ pkgs.findutils }/bin/find ${ structure-directory }/resources/${ bash-variable "OLD_SALT" } -type f -exec ${ pkgs.coreutils }/bin/shred --force --remove {} \; &&
                                                                            ${ pkgs.coreutils }/bin/rm --recursive --force ${ structure-directory }/resources/${ bash-variable "OLD_SALT" }
                                                                          fi
                                                                        fi
                                                                      else
                                                                        ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ bash-variable 0 } ${ bash-variable "OLD_SALT" } | ${ at } now + 1 min
                                                                      fi &&
                                                                      ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delock-resources-directory" ( strip delock-resources-directory )} ${ bash-variable "OLD_SALT" } | ${ at } now
                                                                    '' ;
                                                                  pre-salt = builtins.hashString "sha512" ( builtins.concatStringsSep "" [ ( builtins.toString track.index ) _salt _init _release ] ) ;
                                                                  program = "${ pkgs.writeShellScript "program" ( strip script ) } $( ${ pkgs.coreutils }/bin/date +%s ) ${ bash-variable "$" }" ;
                                                                  script =
                                                                    ''
                                                                      TIMESTAMP=${ bash-variable 1 } &&
                                                                      export SALT=$( ${ pkgs.coreutils }/bin/echo ${ pre-salt } ${ _salt } | ${ pkgs.coreutils }/bin/md5sum | ${ pkgs.coreutils }/bin/cut --bytes -32 ) &&
                                                                      if [ ! -d ${ structure-directory } ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                                      fi &&
                                                                      exec 201<>${ structure-directory }/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s 201 &&
                                                                      if [ ! -d ${ structure-directory }/resources ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resources
                                                                      fi &&
                                                                      exec 202<>${ structure-directory }/resources/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s 202 &&
                                                                      if [ ! -d ${ structure-directory }/resources/${ bash-variable "SALT" } ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resources/${ bash-variable "SALT" }
                                                                      fi &&
                                                                      exec 203<>${ structure-directory }/resources/${ bash-variable "SALT" }/lock &&
                                                                      ${ pkgs.flock }/bin/flock 203 &&
                                                                      ${ pkgs.coreutils }/bin/echo ${ bash-variable 2 } > $( ${ pkgs.coreutils }/bin/mktemp --suffix ".pid" ${ structure-directory }/resources/${bash-variable "SALT" }/XXXXXXXX ) &&
                                                                      if [ ! -e ${ structure-directory }/resources/${ bash-variable "SALT" }/resource ]
                                                                      then
                                                                        ${ _init }
                                                                      fi &&
                                                                      ${ pkgs.coreutils }/bin/echo ${ structure-directory }/resources/${ bash-variable "SALT" }/resource &&
                                                                      ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "delock-resources-dir" ( strip delock-resources-dir ) } ${ bash-variable "SALT" } | ${ at } now 2> /dev/null
                                                                    '' ;
                                                                  in if show then "$( ${ pkgs.coreutils }/bin/cat $( ${ program } ) )" else "$( ${ program } )" ;
                                                        to-string =
                                                          let
                                                            path = track : builtins.toString track.reduced ;
                                                            string = track : track.reduced ;
                                                            undefined = track : track.throw "3ebbf22e-ebf7-49e4-a70a-207058c94c34" ;
                                                            in visit { path = path ; string = string ; undefined = undefined ; } ;
                                                        unsalted =
                                                          salt : init : show :
                                                            let
                                                              bool = track :
                                                                if salt then
                                                                  if track.reduced then to-string init
                                                                  else builtins.toFile "resource" ( to-string init )
                                                                else
                                                                  if track.reduced then builtins.readFile init
                                                                  else to-string init ;
                                                              undefined = track : track.throw "3b1457d8-1f6b-4d5b-912b-5f6fe0c845a6" ;
                                                              in visit { bool = bool ; undefined = undefined ; } show ;
                                                        in track.reduced fun ;
                                                      list = track : track.reduced ;
                                                      set = track : track.reduced ;
                                                      undefined = track : track.throw "a66f1f44-3434-40cb-8e2e-e20481fa4c7b" ;
                                                      in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } resources ;
                                                  structure-directory = structure-directory ;
                                                  temporary-dir = bash-variable locals.temporary-dir ;
                                            } ;
                                        tokenizer = seed : builtins.concatStringsSep "_" [ "LOCAL" ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] ;
                                        variable =
                                          input : tokenizer : check :
                                            let
                                              indexed =
                                                let
                                                  list = track : builtins.concatLists track.reduced ;
                                                  set = track : builtins.concatLists ( builtins.attrValues track.reduced ) ;
                                                  string = track : [ track.reduced ] ;
                                                  undefined = track : builtins.throw "380398e0-9b6c-4bc9-b6ab-acc09fb2f70a" ;
                                                  in visit { list = list ; set = set ; string = string ; undefined = undefined ; } input ;
                                              seeded =
                                                let
                                                  reducer =
                                                    previous : current :
                                                      try
                                                        (
                                                          seed :
                                                            let
                                                              token = tokenizer seed ;
                                                              in
                                                                {
                                                                  success =
                                                                    let
                                                                      is-not-in-string = if check then true else builtins.replaceStrings [ token ] [ "" ] string == string ;
                                                                      is-unique = builtins.all ( t : t != token ) previous ;
                                                                      is-not-small = seed > 2 ;
                                                                      in is-not-in-string && is-unique && is-not-small ;
                                                                  value = builtins.concatLists [ previous [ token ] ] ;
                                                                }
                                                        ) ;
                                                  in builtins.foldl' reducer [ ] indexed ;
                                              to-list =
                                                let
                                                  list = track : builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                                  set = track : track.reduced ;
                                                  string = track : { "${ track.reduced }" = builtins.elemAt seeded track.index ; } ;
                                                  undefined = track : builtins.throw "4aad19a1-9b4e-4dec-b6b2-724a6b1c8e68" ;
                                                  in visit { list = list ; set = set ; string = string ; undefined = undefined ; } input ;
                                              in if builtins.typeOf to-list == "string" then builtins.throw "2d15c35d-cfcb-4a5e-94fc-c5d1cc8fccea" else to-list ;
                                        in if target == "hook" then hook else if target == "input" then input else command ;
                                  list = track : track.reduced ;
                                  set = track : track.reduced ;
                                  undefined = track : builtins.throw "f92a4a30-d3d5-40cb-adfc-d23da3b3b3ef" ;
                                  in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } scripts ;
                            bash-variable = flake "bash-variable" ;
                            buildInputs = builtins.attrValues ( builtins.mapAttrs pkgs.writeShellScriptBin ( inputs ( _scripts "input" ) ) ) ;
                            contains = string : target : builtins.replaceStrings [ target ] [ "" ] string != string ;
                            flake = name : if builtins.hasAttr name _flakes then builtins.getAttr name _flakes else builtins.throw "02b10e6f-b099-4bde-afec-9caa68e39950" ;
                            globals =
                              let
                                attrs = [ "timestamp" "process" "resource-dir" ] ;
                                indexed =
                                  let
                                    list = track : builtins.concatLists track.reduced ;
                                    set = track : builtins.concatLists ( builtins.attrValues track.reduced ) ;
                                    string = track : [ track.reduced ] ;
                                    undefined = track : track.throw "d15d5429-2fee-4162-9da4-b88981624aa3" ;
                                    in visit { list = list ; set = set ; string = string ; undefined = undefined ; } attrs ;
                                seeded =
                                  let
                                    reducer =
                                      previous : current :
                                        try
                                          (
                                            seed :
                                              let
                                                token = builtins.concatStringsSep "_" [ "GLOBAL" ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] ;
                                                in
                                                  {
                                                    success = builtins.all ( p : p != token ) previous ;
                                                    value = builtins.concatLists [ previous [ token ] ] ;
                                                  }
                                          ) ;
                                    in builtins.foldl' reducer [ ] indexed ;
                                to-list =
                                  let
                                    list = track : builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                    set = track : track.reduced ;
                                    string = track : { "${ track.reduced }" = builtins.elemAt seeded track.index ; } ;
                                    undefined = track : builtins.throw "4aad19a1-9b4e-4dec-b6b2-724a6b1c8e68" ;
                                    in visit { list = list ; set = set ; string = string ; undefined = undefined ; } attrs ;
                                in to-list ;
                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                            shellHook = hook ( _scripts "hook" ) ;
                            strip = flake "strip" ;
                            try = flake "try" ;
                            visit = flake "visit" ; 
                            in pkgs.mkShell { buildInputs = buildInputs ; shellHook = shellHook ; } ;
                      }
                  ) ;
            }
          ) ;
  }