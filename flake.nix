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
                            _resources =
                              let
                                lambda =
                                  track :
                                    let
				      resource =
                                        init : release : salt :
                                          let
                                            unsalted-fun =
                                              show :
                                                if builtins.typeOf show != "bool" then builtins.throw "2400375f-9520-4776-a2dd-eb15aca98e6a"
                                                else if salt then
                                                  if show then builtins.toString init
                                                  else builtins.toFile "resource" ( builtins.toString init )
                                                else
                                                  if builtins.typeOf init != "path" then builtins.throw "9301948f-2a11-4ef4-b00b-3fb3cbcb7d18"
                                                  else if show then builtins.readFile ( builtins.import init )
                                                  else init ;
                                            in unsalted-fun ;
				      	    in track.reduced resource ;
                                list = track : track.reduced ;
				set = track : track.reduced ;
				undefined = track : builtins.throw "4cfd5cbe-4624-445c-9fd1-2ac368c5ee56" ;
				in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } resources ;
                            _scripts =
                              target :
                                let
                                  lambda =
                                    track :
                                      let
                                        arguments =
                                          {
                                            numbers =
                                              {
                                                structure-directory = [ "init" "release" ] ;
                                                temporary-directory = [ "init" "release" ] ;
                                                temporary-dir = [ "init" "release" ] ;
                                                logging-directory = [ "init" "release" ] ;
                                                logging-dir = [ "init" "release" ] ;
                                                logs = [ "init" "release" ] ;
                                              } ;
                                            variables =
                                              {
                                                temporary-dir = [ "init" ] ;
                                                logging-dir = [ "init" ] ;
                                                trap = [ "exec" "init" ] ;
                                              }  ;
                                          } ;
                                        command = pkgs.writeShellScript "command" input ;
                                        date-format = "%Y-%m-%d-%H-%M-%S" ;
                                        hook = track.reduced ( structure numbers variables ) ;
                                        identity = x : x ;
                                        input =
                                          let
                                            is-temporary = builtins.replaceStrings [ variables.temporary-dir.init ] [ "" ] hook != hook ;
                                            logging =
                                              ''
                                                # BEGIN LOGGING
                                                if [ ! -d ${ structure-directory }/logging ]
                                                then
                                                  ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logging
                                                fi &&
                                                exec ${ numbers.logging-directory.init }<>${ structure-directory }/logging/lock &&
                                                ${ pkgs.flock }/bin/flock -s ${ numbers.logging-directory.init } &&
                                                export ${ variables.logging-dir.init }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/logging/XXXXXXXX ) &&
                                                exec ${ numbers.logging-dir.init }<>${ bash-variable variables.logging-dir.init }/lock &&
                                                ${ pkgs.flock }/bin/flock ${ numbers.logging-dir.init } &&
                                                # END LOGGING
                                              '' ;
                                            main =
                                              ''
                                                if [ ! -d ${ structure-directory } ]
                                                then
                                                  ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                fi &&
                                                exec ${ numbers.structure-directory.init }<>${ structure-directory }/lock &&
                                                ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory.init } &&
                                                ${ builtins.replaceStrings [ "\n" ] [ ( if is-temporary then "\n" else "\n# " ) ] ( strip temporary ) }
                                                ${ strip logging }
                                                ${ strip trap }
                                                ${ pkgs.time }/bin/time --format "${ time-format }" --output ${ bash-variable variables.logging-dir.init }/time ${ program } ${ bash-variable "@" } \
                                                  > >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts ${ date-format } > ${ bash-variable variables.logging-dir.init }/out 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stdout" ) \
                                                  2> >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts ${ date-format } > ${ bash-variable variables.logging-dir.init }/err 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stderr" )
                                              '' ;
                                            program = pkgs.writeShellScript "program" ( strip hook ) ;
                                            temporary =
                                              ''
                                                # BEGIN TEMPORARY
                                                if [ ! -d ${ structure-directory }/temporary ]
                                                then
                                                  ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                                fi &&
                                                exec ${ numbers.temporary-directory.init }<>${ structure-directory }/temporary/lock &&
                                                ${ pkgs.flock }/bin/flock -s ${ numbers.temporary-directory.init } &&
                                                export ${ variables.temporary-dir.init }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                                exec ${ numbers.temporary-dir.init }<>${ bash-variable variables.temporary-dir.init }/lock &&
                                                ${ pkgs.flock }/bin/flock ${ numbers.temporary-dir.init }
                                                # END TEMPORARY
                                              '' ;
                                            time-format =
                                              let
                                                base = "xDEFIKMOPRSUWXZcekprstwC" ;
                                                generator = index : builtins.concatStringsSep "" [ "%" ( builtins.substring index 1 base ) "\\n" ] ;
                                                length = builtins.stringLength base ;
                                                list = builtins.genList generator length ;
                                                in builtins.concatStringsSep "" list ;
                                            trap =
                                              let
                                                delete-temporary-dir =
                                                  ''
                                                    # delete temporary dir
                                                    if [ -d ${ bash-variable variables.temporary-dir.init } ]
                                                    then
                                                      exec ${ numbers.structure-directory.release }<>${ structure-directory }/lock &&
                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory.release } &&
                                                      if [ -d ${ bash-variable variables.temporary-dir.init } ]
                                                      then
                                                        exec ${ numbers.logging-directory.release }<>${ structure-directory }/temporary/lock &&
                                                        ${ pkgs.flock }/bin/flock -s ${ numbers.logging-directory.release } &&
                                                        if [ -d ${ bash-variable variables.temporary-dir.init } ]
                                                        then
                                                          exec ${ numbers.logging-dir.release }<>${ bash-variable variables.temporary-dir.init }/lock &&
                                                          ${ pkgs.flock }/bin/flock ${ numbers.logging-dir.release } &&
                                                          ${ pkgs.findutils }/bin/find ${ bash-variable variables.temporary-dir.init } -type f -exec ${ pkgs.coreutils }/bin/shred --remove {} \; &&
                                                          ${ pkgs.coreutils }/bin/rm --recursive --force ${ bash-variable variables.temporary-dir.init }
                                                        fi
                                                      fi
                                                    fi &&
                                                    ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "program" ( strip delock-temporary-directory ) } | ${ at } now
                                                  '' ;
                                                delock-logging-dir =
                                                  ''
                                                    # delock logging dir
                                                    if [ -d ${ bash-variable variables.logging-dir.init } ]
                                                    then
                                                      exec ${ numbers.structure-directory.release }<>${ structure-directory }/lock &&
                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory.release } &&
                                                      if [ -d ${ bash-variable variables.logging-dir.init } ]
                                                      then
                                                        exec ${ numbers.logging-directory.release }<>${ structure-directory }/logging/lock &&
                                                        ${ pkgs.flock }/bin/flock -s ${ numbers.logging-directory.release } &&
                                                        if [ -d ${ bash-variable variables.logging-dir.init } ]
                                                        then
                                                          exec ${ numbers.logging-dir.release }<>${ bash-variable variables.logging-dir.init }/lock &&
                                                          ${ pkgs.flock }/bin/flock ${ numbers.logging-dir.release } &&
                                                          ${ pkgs.coreutils }/bin/rm ${ bash-variable variables.logging-dir.init }/lock &&
                                                          ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ bash-variable variables.logging-dir.init }
                                                        fi
                                                      fi
                                                    fi &&
                                                    ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "program" ( strip delock-logging-directory ) } | ${ at } now 2>> debug
                                                  '' ;
                                                delock-logging-directory =
                                                  ''
                                                    # delock logging directory
                                                    if [ -d ${ structure-directory }/logging ]
                                                    then
                                                      exec ${ numbers.structure-directory.release }<>${ structure-directory }/lock &&
                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory.release } &&
                                                      if [ -d ${ structure-directory }/logging ]
                                                      then
                                                        exec ${ numbers.logging-directory.release }<>${ structure-directory }/logging/lock &&
                                                        ${ pkgs.flock }/bin/flock ${ numbers.logging-directory.release } &&
                                                        ${ pkgs.coreutils }/bin/rm ${ structure-directory }/logging/lock &&
                                                        ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ structure-directory }/logging
                                                      fi
                                                    fi &&
                                                    ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "program" ( strip delock-structure-directory ) } | ${ at } now
                                                  '' ;
                                                delock-structure-directory =
                                                  ''
                                                    # delock structure directory
                                                    if [ -d ${ structure-directory } ]
                                                    then
                                                      exec ${ numbers.structure-directory.release }<>${ structure-directory }/lock &&
                                                      ${ pkgs.flock }/bin/flock ${ numbers.structure-directory.release } &&
                                                      ${ pkgs.coreutils }/bin/rm ${ structure-directory }/lock &&
                                                      ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ structure-directory }
                                                    fi
                                                  '' ;
                                                delock-temporary-directory =
                                                  ''
                                                    # delock temporary directory
                                                    if [ -d ${ structure-directory }/temporary ]
                                                    then
                                                      exec ${ numbers.structure-directory.release }<>${ structure-directory }/lock &&
                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory.release } &&
                                                      if [ -d ${ structure-directory }/temporary ]
                                                      then
                                                        exec ${ numbers.temporary-directory.release }<>${ structure-directory }/temporary/lock &&
                                                        ${ pkgs.flock }/bin/flock ${ numbers.temporary-directory.release } &&
                                                        ${ pkgs.coreutils }/bin/rm ${ structure-directory }/temporary/lock &&
                                                        ${ pkgs.coreutils }/bin/rmdir --ignore-fail-on-non-empty ${ structure-directory }/temporary
                                                      fi
                                                    fi &&
                                                    ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "program" ( strip delock-structure-directory ) } | ${ at } now
                                                  '' ;
                                                finish-logging =
                                                  ''
                                                    # finish logging
                                                    if [ -d ${ bash-variable variables.logging-dir.init } ]
                                                    then
                                                      exec ${ numbers.structure-directory.release }<>${ structure-directory }/lock &&
                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory.release } &&
                                                      if [ -d ${ bash-variable variables.logging-dir.init } ]
                                                      then
                                                        exec ${ numbers.logging-directory.release }<>${ structure-directory }/logging/lock &&
                                                        ${ pkgs.flock }/bin/flock -s ${ numbers.logging-directory.release } &&
                                                        if [ -d ${ bash-variable variables.logging-dir.init } ]
                                                        then
                                                          exec ${ numbers.logging-dir.release }<>${ bash-variable variables.logging-dir.init }/lock &&
                                                          ${ pkgs.flock }/bin/flock ${ numbers.logging-dir.release }
                                                          ${ pkgs.coreutils }/bin/touch ${ bash-variable variables.logging-dir.init }/out &&
                                                          ${ pkgs.coreutils }/bin/touch ${ bash-variable variables.logging-dir.init }/err &&
                                                          ${ pkgs.coreutils }/bin/chmod 0400 ${ bash-variable variables.logging-dir.init }/out &&
                                                          ${ pkgs.coreutils }/bin/chmod 0400 ${ bash-variable variables.logging-dir.init }/err &&
                                                          ${ pkgs.coreutils }/bin/chmod 0400 ${ bash-variable variables.logging-dir.init }/time &&
                                                          ${ pkgs.findutils }/bin/find ${ bash-variable variables.logging-dir.init } -type f -name '*.*' -exec ${ pkgs.coreutils }/bin/chmod 0400 {} \;
                                                        fi
                                                      fi
                                                    fi &&
                                                    ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "program" ( strip delock-logging-dir ) } | ${ at } now
                                                  '' ;
                                                in
                                                  ''
                                                    # BEGIN TRAP
                                                    ${ variables.trap.init } ( )
                                                    {
                                                      ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "program" ( strip finish-logging ) } | ${ at } now 2> /dev/null &&
                                                      ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScript "program" ( strip delete-temporary-dir ) } | ${ at } now 2> /dev/null &&
                                                      if [ -f ${ bash-variable variables.logging-dir.init }/time ] && [ ! -s ${ bash-variable variables.logging-dir.init }/err ]
                                                      then
                                                        exit $( ${ pkgs.coreutils }/bin/head --lines 1 ${ bash-variable variables.logging-dir.init }/time )
                                                      elif [ -f ${ bash-variable variables.logging-dir.init }/time ]
                                                      then
                                                        exit 64
                                                      elif [ ! -s ${ bash-variable variables.logging-dir.init }/err ]
                                                      then
                                                        exit 65
                                                      else
                                                        exit 66
                                                      fi
                                                    } &&
                                                    trap ${ variables.trap.init } EXIT
                                                    # END TRAP
                                                  '' ;
                                            in main ;
                                        numbers = variable arguments.numbers builtins.toString false ;
                                        string =
                                          let
                                            numbers = variable arguments.numbers builtins.toString true ;
                                            variables = variable arguments.variables builtins.toString true ;
                                            in track.reduced ( structure numbers variables ) ;
                                        structure =
                                          numbers : variables :
                                            {
                                              commands = _scripts "command" ;
                                              flakes = flakes ;
                                              logger =
                                                name :
                                                  ">( ${ pkgs.moreutils }/bin/ts ${ date-format } > $( ${ pkgs.mktemp }/bin/mktemp ${ bash-variable variables.logging-dir.init }/${ builtins.hashString "sha512" ( builtins.toString name ) }.XXXXXXXX ) 2> /dev/null )" ;
                                              logs =
                                                pkgs.writeShellScript
                                                  "logs"
                                                  (
                                                    let
                                                      log =
                                                        pkgs.writeShellScript
                                                          "log"
                                                          ''
                                                            exec ${ numbers.logging-dir.init }<>${ bash-variable "1" }/lock &&
                                                            ${ pkgs.flock }/bin/flock -n ${ numbers.logging-dir.init } &&
                                                            if [ -f ${ bash-variable "1" }/out ] && [ $( ${ pkgs.coreutils }/bin/stat --format "%a" ${ bash-variable "1" }/out ) -eq 0400 ]
                                                            then
                                                              ${ pkgs.coreutils }/bin/mv ${ bash-variable "1" } ${ bash-variable variables.temporary-dir.init }
                                                            fi
                                                          '' ;
                                                      in
                                                        ''
                                                          ${ pkgs.findutils }/bin/find ${ structure-directory }/logging -mindepth 1 -maxdepth 1 -type d -exec ${ log } {} \;
                                                        ''
                                                  ) ;
                                              pkgs = pkgs ;
					      resources = _resources ;
					      temporary-dir = bash-variable variables.temporary-dir.init ;
					    } ;
                                        tokenizer = seed : builtins.concatStringsSep "_" [ "VARIABLE" ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] ;
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
                                        variables = variable arguments.variables tokenizer false ;                                            
                                        in if target == "hook" then hook else if target == "input" then input else command ;
                                  list = track : track.reduced ;
                                  set = track : track.reduced ;
                                  undefined = track : builtins.throw "f92a4a30-d3d5-40cb-adfc-d23da3b3b3ef" ;
                                  in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } scripts ;
                            bash-variable = flake "bash-variable" ;
                            buildInputs = builtins.attrValues ( builtins.mapAttrs pkgs.writeShellScriptBin ( inputs ( _scripts "input" ) ) ) ;
                            flake = name : if builtins.hasAttr name _flakes then builtins.getAttr name _flakes else builtins.throw "02b10e6f-b099-4bde-afec-9caa68e39950" ;
                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                            shellHook = hook ( _scripts "hook" ) ;
                            strip = flake "strip" ;
                            timestamp-variable =
                              try
                                (
                                  seed :
                                    let
                                      success =
                                        target :
                                          let
                                            list = track : builtins.all ( t : t ) track.reduced ;
                                            set = track : builtins.all ( t : t ) ( builtins.attrValues track.reduced ) ;
                                            string = track : builtins.replaceStrings [ token ] [ "" ] track.reduced == track.reduced ;
                                            undefined = track : builtins.throw "eb1574dd-8c12-47df-9c0e-4fc2031247ac" ;
                                            in visit { list = list ; set = set ; string = string ; undefined = undefined ; } ( _scripts target ) ;
                                      token = builtins.concatStringsSep "_" [ "TIMESTAMP" ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] ;
                                      in
                                        {
                                          success = ( success "hook" ) && ( success "input" ) && ( success "command" ) ;
                                          value = token ;
                                        }
                                ) ;
                            try = flake "try" ;
                            visit = flake "visit" ; 
                            in pkgs.mkShell { buildInputs = buildInputs ; shellHook = shellHook ; } ;
                      }
                  ) ;
            }
          ) ;
  }