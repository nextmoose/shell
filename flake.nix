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
                                  program =
                                    script :
                                    let
                                      cleanup =
                                        ''
                                          LOG=${ _utils.bash-variable "1" } &&
                                          TEMP=${ _utils.bash-variable "2" } &&
                                          [ -d ${ structure-directory } ] &&
                                          exec ${ numbers.script.structure }<>${ structure-directory }/lock &&
                                          ${ pkgs.flock }/bin/flock -s ${ numbers.script.structure } &&
                                          [ -d ${ structure-directory }/logs ] &&
                                          exec ${ numbers.script.logs }<>${ structure-directory }/logs/lock &&
                                          ${ pkgs.flock }/bin/flock -s ${ numbers.script.logs } &&
                                          [ -d ${ _utils.bash-variable "LOG" } ] &&
                                          exec ${ numbers.script.log }<>${ _utils.bash-variable "LOG" }/lock &&
                                          ${ pkgs.flock }/bin/flock -s ${ numbers.script.log } &&
                                          ${ pkgs.coreutils }/bin/touch \
                                          ${ _utils.bash-variable "LOG" }/out \
                                          ${ _utils.bash-variable "LOG" }/err \
                                          ${ _utils.bash-variable "LOG" }/din \
                                          ${ _utils.bash-variable "LOG" }/debug \
                                          ${ _utils.bash-variable "LOG" }/notes
                                          ${ pkgs.coreutils }/bin/chmod \
                                            0400 \
                                            ${ _utils.bash-variable "LOG" }/out \
                                            ${ _utils.bash-variable "LOG" }/err \
                                            ${ _utils.bash-variable "LOG" }/din \
                                            ${ _utils.bash-variable "LOG" }/debug \
                                            ${ _utils.bash-variable "LOG" }/notes &&
                                          [ -d ${ structure-directory }/temporary ] &&
                                          exec ${ numbers.script.temporaries }<>${ structure-directory }/temporary/lock &&
                                          ${ pkgs.flock }/bin/flock -s ${ numbers.script.temporaries } &&
                                          if [ -d "${ _utils.bash-variable "TEMP" }" ]
                                          then
                                            exec ${ numbers.script.temporary }<>${ _utils.bash-variable "TEMP" }/lock &&
                                            ${ pkgs.flock }/bin/flock ${ numbers.script.temporary } &&
                                            ${ pkgs.findutils }/bin/find ${ _utils.bash-variable "TEMP" } -type f -exec ${ pkgs.coreutils }/shred --force --remove {} \; &&
                                            ${ pkgs.coreutils }/bin/rm --recursive ${ _utils.bash-variable "TEMP" }
                                          fi &&
                                          ${ unlock.log } ${ _utils.bash-variable "LOG" } 2> /dev/null &&
                                          ${ unlock.temporaries }
                                        '' ;
                                      process =
                                        ''
                                          export ${ variables.script.process }=${ _utils.bash-variable "!" }
                                        '' ;
                                      program =
                                        ''
                                          ${ variables.script.cleanup } ( )
                                          {
                                            ${ pkgs.coreutils }/bin/echo \
                                              ${ pkgs.coreutils }/bin/nice \
                                                --adjustment 19 \
                                                ${ pkgs.writeShellScriptBin "cleanup" ( _utils.strip cleanup ) }/bin/cleanup ${ _utils.bash-variable variables.script.log } ${ _utils.bash-variable variables.shared.temporary } |
                                                ${ at } now 2> /dev/null
                                          } &&
                                          trap ${ variables.script.cleanup } EXIT &&
                                          if [ -z "${ _utils.bash-variable variables.script.time }" ]
                                          then
                                            export ${ variables.script.time }=$( ${ pkgs.coreutils }/bin/date +%s )
                                          fi &&
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
                                          ${ pkgs.writeShellScriptBin "script" ( _utils.strip script ) }/bin/script "${ _utils.bash-variable "@" }" \
                                            > >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable variables.script.log }/out 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stdout" ) \
                                            2> >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable variables.script.log }/err 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stderr" ) &&
                                          if [ -f ${ _utils.bash-variable variables.script.log }/err ] && [ ! -z "$( ${ pkgs.coreutils }/bin/cat ${ _utils.bash-variable variables.script.log }/err )" ]
                                          then
                                            exit ${ numbers.script.err }
                                          fi
                                        '' ;
                                      temporary =
                                        if builtins.replaceStrings [ variables.shared.temporary ] [ "" ] script == script then "export ${ variables.shared.temporary }="
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
                                  programs =
                                    _utils.visit
                                      {
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        string = track : program track.reduced ;
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
                                                  ${ pkgs.coreutils }/bin/rm --recursive ${ structure-directory }/logs/${ _utils.bash-variable "LOG" } &&
                                                  ${ unlock.log } ${ _utils.bash-variable "LOG" } 2> /dev/null
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
                                                    ${ pkgs.coreutils }/bin/cp --recursive ${ _utils.bash-variable "SOURCE" } ${ _utils.bash-variable "TARGET" } &&
                                                    ${ unlock.log } ${ _utils.bash-variable "SOURCE" } 2> /dev/null
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
                                          lambda =
                                            track :
                                              let
                                                resource =
                                                  starter : finisher : salter :
                                                    let
                                                      create = minutes : is-resource :
                                                        let
                                                          cleanup =
                                                            ''
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b b3bb4c62-fee4-4561-9d1f-9ca2b91586ad >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e &&
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b 264983a0-abfc-45f1-9f6e-b48e3ad798f7 >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e ${ builtins.toString minutes } &&
							      ${ unlock.link } ${ _utils.bash-variable "1" } 2> /dev/null &&
							      ${ unlock.resource } ${ _utils.bash-variable "2" } 2> /dev/null &&
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b 4428a3ad-c340-4ac9-b5bd-d511cb48bfd3 >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e &&
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b a33be843-2cbd-400f-ad1f-e2ef0a9c5990 >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustments 19 ${ pkgs.writeShellScriptBin "delete-link" ( program ( _utils.strip ( delete-link ) ) ) }/bin/delete-link ${ _utils.bash-variable "1" } ${ _utils.bash-variable "2" } &&
 							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b 39ad2910-f284-4f89-8b0b-10cb93cf775e >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e ${ at } now + ${ builtins.toString minutes }min &&
							      ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustments 19 ${ pkgs.writeShellScriptBin "delete-link" ( program ( _utils.strip ( delete-link ) ) ) }/bin/delete-link ${ _utils.bash-variable "1" } ${ _utils.bash-variable "2" } | ${ at } now + ${ builtins.toString minutes }min
                                                            '' ;
                                                          delete-link =
                                                            ''
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b dd2d605f-6f61-4294-9bb2-649af18a77ac >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e &&
                                                              LINK_DIRECTORY=${ _utils.bash-variable "1" } &&
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b cd71e0c6-cab5-4b8c-8501-7cdbdc9b1781 >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e ${ _utils.bash-variable "LINK_DIRECTORY" } &&
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b d6e78f03-f988-4a69-bf2d-c709c0a3c055 >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e &&
                                                              RESOURCE_DIRECTORY=${ _utils.bash-variable "2" } &&
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b 9d39af1b-e434-44a3-95d8-055e5c28b420 >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e ${ _utils.bash-variable "RESOURCE_DIRECTORY" } &&
                                                              [ -d ${ structure-directory } ] &&
                                                              exec 202<>${ structure-directory }/lock &&
                                                              ${ pkgs.flock }/bin/flock -s 202 &&
                                                              [ -d ${ structure-directory }/links ] &&
                                                              exec 295<>${ structure-directory }/links/lock &&
                                                              ${ pkgs.flock }/bin/flock -s 295 &&
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b 260ddf65-213b-494c-ae08-c4889fa7e622 >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e &&
                                                              [ -d ${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" } ] &&
							      ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b af23da27-8216-4c7a-8acb-4d204041ea2b >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e &&
                                                              exec 261<>${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" }/lock &&
                                                              ${ pkgs.flock }/bin/flock 261 &&
                                                              ${ pkgs.coreutils }/bin/rm ${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" }/link ${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" }/lock &&
                                                              ${ pkgs.coreutils }/bin/rm --recursive ${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" } &&
							      ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/nice --adjustment 19 ${ pkgs.writeShellScriptBin "delete-resource" ( _utils.strip delete-resource ) }/bin/delete-resource ${ _utils.bash-variable "RESOURCE_DIRECTORY" } | ${ at } now
                                                            '' ;
							  delete-resource =
							    ''
							      RESOURCE_DIRECTORY=${ _utils.bash-variable "1" } &&
							      [ $( ${ pkgs.coreutils }/bin/dirname ${ _utils.bash-variable "RESOURCE_DIRECTORY" } ) == ${ structure-directory }/links ] &&
							      [ -d ${ structure-directory }/resources ] &&
                                                              exec 241<>${ structure-directory }/resources/lock &&
                                                              ${ pkgs.flock }/bin/flock -s 241 &&
							      [ -d ${ _utils.bash-variable "RESOURCE_DIRECTORY" } ] &&
							      exec 278<>${ _utils.bash-variable "RESOURCE_DIRECTORY" }/lock &&
							      ${ pkgs.flock }/bin/flock 278 &&
							      ${ pkgs.findutils }/bin/find ${ _utils.bash-variable "RESOURCE_DIRECTORY" } -type f -exec ${ pkgs.coreutils }/bin/shred --force --remove {} \; &&
							      ${ pkgs.coreutils }/bin/rm --recursive ${ _utils.bash-variable "RESOURCE_DIRECTORY" }
							    '' ;
                                                          item = "$( ${ pkgs.writeShellScriptBin "resource" ( _utils.strip resource ) }/bin/resource ${ _utils.bash-variable "1" } )" ;
                                                          resource =
                                                            ''
                                                              cleanup ( )
                                                              {
							        ${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b 2726ad25-c5e7-4e6b-8858-873ed250b86b >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e &&
							        TIME=$( ${ pkgs.coreutils }/bin/echo \
                                                                  ${ pkgs.coreutils }/bin/nice \
                                                                    --adjustment 19 \
                                                                    ${ pkgs.writeShellScriptBin "cleanup" ( program cleanup ) }/bin/cleanup ${ _utils.bash-variable "LINK_DIRECTORY" } ${ _utils.bash-variable "RESOURCE_DIRECTORY" } | ${ at } now 2> >( ${ pkgs.coreutils }/bin/tail --lines 1 ) ) &&
								${ pkgs.coreutils }/bin/echo 9a4e5cb1-8a21-4000-af73-9f1b41c26b2b 844c85f3-6247-4629-a38f-970a9ddba033 ${ _utils.bash-variable "TIME" } >> ${ structure-directory }/afa82912-e555-46ea-b5be-a178721b367e
						              } &&
                                                              trap cleanup EXIT &&
                                                              if [ ! -d ${ structure-directory } ]
                                                              then
                                                                ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                              fi &&
                                                              exec 137<>${ structure-directory }/lock &&
                                                              ${ pkgs.flock }/bin/flock -s 137 &&
                                                              if [ ! -d ${ structure-directory }/links ]
                                                              then
                                                                ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/links
                                                              fi &&
                                                              exec 153<>${ structure-directory }/links/lock &&
                                                              ${ pkgs.flock }/bin/flock -s 153 &&
                                                              ${ "LINK_DIRECTORY" }=$( ${ pkgs.coreutils }/bin/echo ${ builtins.hashString "sha512" ( builtins.concatStringsSep "" [ starter finisher ] ) }-$( ${ pkgs.writeShellScriptBin "salter" ( program salter ) }/bin/salter ${ _utils.bash-variable variables.script.time } ) | ${ pkgs.coreutils }/bin/sha512sum | ${ pkgs.coreutils }/bin/cut --bytes -128 ) &&
                                                              if [ -d ${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" } ] && exec 203<>${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" }/lock && ${ pkgs.flock }/bin/flock -s 203
                                                              then
                                                                ${ pkgs.coreutils }/bin/readlink ${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" }/link
                                                              else
                                                                ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" } &&
                                                                exec 119<>${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" }/lock &&
                                                                ${ pkgs.flock }/bin/flock -s 119 &&
                                                                if [ ! -d ${ structure-directory }/resources ]
                                                                then
                                                                  ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resources
                                                                fi &&
                                                                exec 129<>${ structure-directory }/resources/lock &&
                                                                ${ pkgs.flock }/bin/flock -s 129 &&
                                                                RESOURCE_DIRECTORY=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/resources/XXXXXXXX ) &&
                                                                exec 168<>${ _utils.bash-variable "RESOURCE_DIRECTORY" }/lock &&
                                                                ${ pkgs.flock }/bin/flock 168 &&
                                                                ${ pkgs.writeShellScriptBin "program" ( program ( _utils.strip starter ) ) }/bin/program ${ _utils.bash-variable "RESOURCE_DIRECTORY" }/resource &&
                                                                ${ pkgs.coreutils }/bin/ln --symbolic ${ _utils.bash-variable "RESOURCE_DIRECTORY" }/resource ${ structure-directory }/links/${ _utils.bash-variable "LINK_DIRECTORY" }/link &&
                                                                ${ pkgs.coreutils }/bin/echo ${ _utils.bash-variable "RESOURCE_DIRECTORY" }/resource
                                                              fi
                                                            '' ;
                                                          in if is-resource then "$( ${ pkgs.coreutils }/bin/cat ${ item } )" else item ;
                                                      in create ;
                                                in track.reduced resource ;
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
                                      commands =
                                       let
                                         mapper =
                                           name : value :
                                             let
                                               derivation =
                                                 ''
                                                   ${ pkgs.coreutils }/bin/echo \
                                                     ${ pkgs.coreutils }/bin/nice \
                                                       --adjustment 19 \
                                                       ${ pkgs.writeShellScriptBin "script" ( _utils.strip value ) }/bin/script "${ _utils.bash-variable "@" }" |
                                                       ${ at } now 2> /dev/stderr
                                                 '' ;
                                               in "${ pkgs.writeShellScriptBin "derivation" ( _utils.strip derivation ) }/bin/derivation" ;
                                         in builtins.mapAttrs mapper scripts ;
                                      scripts =
                                        {
                                          log =
                                            ''
                                              [ -d ${ structure-directory } ] &&
                                              exec ${ numbers.script.structure }<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock -s ${ numbers.script.structure } &&
                                              [ -d ${ structure-directory }/logs ] &&
                                              exec ${ numbers.script.logs }<>${ structure-directory }/logs/lock &&
                                              ${ pkgs.flock }/bin/flock -s ${ numbers.script.logs } &&
                                              [ -d ${ _utils.bash-variable "1" } ] &&
                                              exec ${ numbers.script.log }<>${ _utils.bash-variable "1" }/lock &&
                                              ${ pkgs.flock }/bin/flock ${ numbers.script.log } &&
                                              ${ pkgs.coreutils }/bin/rm ${ _utils.bash-variable "1" }/lock &&
                                              ${ commands.logs }
                                           '' ;
                                          logs =
                                            ''
                                              [ -d ${ structure-directory } ] &&
                                              exec ${ numbers.script.structure }<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock -s ${ numbers.script.structure } &&
                                              [ -d ${ structure-directory }/logs ] &&
                                              exec ${ numbers.script.logs }<>${ structure-directory }/logs/lock &&
                                              ${ pkgs.flock }/bin/flock ${ numbers.script.logs } &&
                                              ${ pkgs.coreutils }/bin/rm ${ structure-directory }/logs/lock &&
                                              ${ commands.structure }
                                           '' ;
                                          link =
                                            ''
                                              ${ pkgs.coreutils }/bin/echo f8231a7c-b5e9-4fd3-b33e-43f0a6a154ca 9320a0ac-7570-4890-a50b-8c4d44076531 BEGIN ${ _utils.bash-variable "1" } END >> ${ structure-directory }/2bbd83b5-ba74-4071-9cd1-cac0a2008a4d &&
                                              [ -d ${ structure-directory } ] &&
                                              exec 150<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock -s 150 &&
                                              [ -d ${ structure-directory }/links ] &&
                                              exec 140<>${ structure-directory }/links/lock &&
                                              ${ pkgs.flock }/bin/flock -s 140 &&
                                              ${ pkgs.coreutils }/bin/echo f8231a7c-b5e9-4fd3-b33e-43f0a6a154ca 2d65358f-cafd-4637-af01-e40742dc42f1 >> ${ structure-directory }/2bbd83b5-ba74-4071-9cd1-cac0a2008a4d &&
                                              [ -d ${ structure-directory }/links/${ _utils.bash-variable "1" } ] &&
                                              ${ pkgs.coreutils }/bin/echo f8231a7c-b5e9-4fd3-b33e-43f0a6a154ca 08bda07b-e3c2-48df-9ff2-b00986d6e2bd >> ${ structure-directory }/2bbd83b5-ba74-4071-9cd1-cac0a2008a4d &&
                                              exec 139<>${ structure-directory }/links/${ _utils.bash-variable "1" }/lock &&
                                              ${ pkgs.flock }/bin/flock 139 &&
                                              ${ pkgs.coreutils }/bin/echo f8231a7c-b5e9-4fd3-b33e-43f0a6a154ca d5fe1a17-3704-4403-84a8-97b261f78010 >> ${ structure-directory }/2bbd83b5-ba74-4071-9cd1-cac0a2008a4d &&
                                              ${ pkgs.coreutils }/bin/rm ${ structure-directory }/links/${ _utils.bash-variable "1" }/lock &&
                                              ${ pkgs.coreutils }/bin/echo f8231a7c-b5e9-4fd3-b33e-43f0a6a154ca 86e92b84-8858-41ff-a68e-ad812669ea33 >> ${ structure-directory }/2bbd83b5-ba74-4071-9cd1-cac0a2008a4d &&
                                              ${ commands.links } &&
                                              ${ pkgs.coreutils }/bin/echo f8231a7c-b5e9-4fd3-b33e-43f0a6a154ca c92da3a7-1966-4023-8313-c6896fa33fc8 >> ${ structure-directory }/2bbd83b5-ba74-4071-9cd1-cac0a2008a4d
                                           '' ;
                                          links =
                                            ''
                                              [ -d ${ structure-directory } ] &&
                                              exec 121<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock -s 121 &&
                                              [ -d ${ structure-directory }/links ] &&
                                              exec 186<>${ structure-directory }/links/lock &&
                                              ${ pkgs.flock }/bin/flock 186 &&
                                              ${ pkgs.coreutils }/bin/rm ${ structure-directory }/links/lock &&
                                              ${ commands.structure }
                                           '' ;
                                          resource =
                                            ''
					      [ ${ structure-directory }/resources/$( ${ pkgs.coreutils }/bin/echo ${ _utils.bash-variable "1" } | ${ pkgs.gnused }/bin/sed -e "s#^${ structure-directory }/resources/\(.*\)#\1#"  ) == ${ _utils.bash-variable "1" } ] &&
                                              [ -d ${ structure-directory } ] &&
                                              exec 194<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock -s 194 &&
                                              [ -d ${ structure-directory }/logs ] &&
                                              exec 116<>${ structure-directory }/resources/lock &&
                                              ${ pkgs.flock }/bin/flock -s 116 &&
                                              [ -d ${ _utils.bash-variable "1" } ] &&
                                              exec 113<>${ _utils.bash-variable "1" }/lock &&
                                              ${ pkgs.flock }/bin/flock 113 &&
                                              ${ pkgs.coreutils }/bin/rm ${ _utils.bash-variable "1" }/lock &&
                                              ${ commands.resources }
                                           '' ;
                                          resources =
                                            ''
                                              [ -d ${ structure-directory } ] &&
                                              exec 101<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock -s 101 &&
                                              [ -d ${ structure-directory }/resources ] &&
                                              exec 110<>${ structure-directory }/logs/lock &&
                                              ${ pkgs.flock }/bin/flock 110 &&
                                              ${ pkgs.coreutils }/bin/rm ${ structure-directory }/resources/lock &&
                                              ${ commands.structure }
                                           '' ;
                                          structure =
                                            ''
                                              [ -d ${ structure-directory } ] &&
                                              exec 198<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock 198 &&
                                              ${ pkgs.coreutils }/bin/rm ${ structure-directory }/lock
                                           '' ;
                                          temporaries =
                                            ''
                                              [ -d ${ structure-directory } ] &&
                                              exec ${ numbers.script.structure }<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock -s ${ numbers.script.structure } &&
                                              [ -d ${ structure-directory }/temporary ] &&
                                              exec ${ numbers.script.temporaries }<>${ structure-directory }/temporary/lock &&
                                              ${ pkgs.flock }/bin/flock ${ numbers.script.temporaries } &&
                                              ${ pkgs.coreutils }/bin/rm ${ structure-directory }/temporary/lock &&
                                              ${ commands.structure }
                                           '' ;
                                        } ;
                                      in commands ;
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
                                        resource = [ "structure" "links" "link" "resources" "resource" "securities" "security" ] ;
                                        script = [ "structure" "logs" "log" "temporaries" "temporary" "err" ] ;
                                      } ;
                                    variables =
                                      {
                                        resource = [ "link" ] ;
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
