  {
    inputs =
      {
        flake-utils.url = "github:numtide/flake-utils?rev=919d646de7be200f3bf08cb76ae1f09402b6f9b4" ;
        nixpkgs.url = "github:NixOs/nixpkgs?rev=7cdce123f56f970e3de40f24f6ec4fafe7cd52b4" ;
        shell.url = "/home/runner/work/shell/shell" ;
      } ;
    outputs =
      { flake-utils , nixpkgs , shell , self } :
        let
          fun =
            system :
              let
                arguments =
                  {
                    build = pkgs ;
                    host = pkgs ;
                    private = "82b71638-804f-4533-b6dc-2f87b7ae5afc" ;
                    scripts =
                      {
                        entrypoint =
                          { target } :
                            ''
                              ${ target.cowsay }/bin/cowsay ENTRY POINT
                            '' ;
                        isolated =
                          {
                            isolated-000 =
                              { bash-variable , hash , isolated , path , process , target , timestamp } :
                                ''
                                  # isolated
                                  # 3c9ad55147a7144f6067327c3b82ea70e7c5426add9ceea4d07dc2902239bf9e049b88625eb65d014a7718f79354608cab0921782c643f0208983fffa3582e40
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ISOLATED=${ isolated { } } &&
                                  DIRECTORY=$( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) &&
                                  NUMBER=$( ${ target.gnutar }/bin/tar --create --owner=938 --group=938 --numeric-owner --directory ${ bash-variable "DIRECTORY" } . | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&


				  ${ target.coreutils }/bin/echo BEFORE &&
                                  ${ target.gnutar }/bin/tar --create --file isolated-000.tar --owner=938 --group=938 --numeric-owner --directory ${ bash-variable "DIRECTORY" } . &&
				  ${ target.coreutils }/bin/cat isolated-000.tar &&
				  ${ target.coreutils }/bin/echo AFTER &&
				  


                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "1ad81d155208933de17925d1b19762983ebdc0e898f7eaea52ddb7a1ddf4b5e061a04c7a44b38a23422ddd1cf3c82250996363244ae46eeb2d0a89312d099592" ]
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                       exit 64
                                  fi
                                '' ;
                            isolated-001 =
                              { bash-variable , hash , isolated , path , process , target , timestamp } :
                                ''
                                  # isolated
                                  # 3c9ad55147a7144f6067327c3b82ea70e7c5426add9ceea4d07dc2902239bf9e049b88625eb65d014a7718f79354608cab0921782c643f0208983fffa3582e40
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ISOLATED=${ isolated { init = scripts : builtins.elemAt scripts.scripts.happy 0 ; } } &&
                                  DIRECTORY=$( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) &&
                                  ${ target.findutils }/bin/find ${ bash-variable "DIRECTORY" } -exec ${ target.coreutils }/bin/touch --date @0 {} \; &&
                                  NUMBER=$( ${ target.gnutar }/bin/tar --create --directory ${ bash-variable "DIRECTORY" } . | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "ISOLATED" } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ${ target.coreutils }/bin/cat ${ bash-variable "ISOLATED" } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "84b45bcc2d9aab2f1c2ce4b15a5b815b8b033b983f6ddc7b763fa94870799c9074841795dbe6ea9beb7973eb8d292605b74d82ed2e554873b15d127e437f35ce" ]
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                       exit 64
                                  fi
                                '' ;
                            isolated-010 =
                              { bash-variable , hash , isolated , path , process , target , timestamp } :
                                ''
                                  # isolated
                                  # 3c9ad55147a7144f6067327c3b82ea70e7c5426add9ceea4d07dc2902239bf9e049b88625eb65d014a7718f79354608cab0921782c643f0208983fffa3582e40
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ISOLATED=${ isolated { release = scripts : builtins.elemAt scripts.scripts.happy 1 ; } } &&
                                  DIRECTORY=$( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) &&
                                  ${ target.findutils }/bin/find ${ bash-variable "DIRECTORY" } -exec ${ target.coreutils }/bin/touch --date @0 {} \; &&
                                  NUMBER=$( ${ target.gnutar }/bin/tar --create --directory ${ bash-variable "DIRECTORY" } . | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "ISOLATED" } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "f61312766062404f855b05bfe5547b23c727d18e07200c3f9b9db15d3a7218269561070675a46d16c07d348cc675e68b032fa10b491ef732d071068d2dcb134e" ]
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                       exit 64
                                  fi
                                '' ;
                            isolated-011 =
                              { bash-variable , hash , isolated , path , process , target , timestamp } :
                                ''
                                  # isolated
                                  # 3c9ad55147a7144f6067327c3b82ea70e7c5426add9ceea4d07dc2902239bf9e049b88625eb65d014a7718f79354608cab0921782c643f0208983fffa3582e40
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ISOLATED=${ isolated { init = scripts : builtins.elemAt scripts.scripts.happy 0 ; release = scripts : builtins.elemAt scripts.scripts.happy 1 ; } } &&
                                  DIRECTORY=$( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) &&
                                  ${ target.findutils }/bin/find ${ bash-variable "DIRECTORY" } -exec ${ target.coreutils }/bin/touch --date @0 {} \; &&
                                  NUMBER=$( ${ target.gnutar }/bin/tar --create --directory ${ bash-variable "DIRECTORY" } . | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "ISOLATED" } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ${ target.coreutils }/bin/cat ${ bash-variable "ISOLATED" } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "345f5668bae6ec65eb073ab93a913aab11a4f3a7a4b48db6ab1419582e7c0faf86f28feba2730c3affe37b0ff0245cb0a110e0270c8b1bca949ddb0fb62f1c80" ]
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                       exit 64
                                  fi
                                '' ;
                            isolated-101 =
                              { bash-variable , hash , isolated , path , process , target , timestamp } :
                                ''
                                  # isolated
                                  # 3c9ad55147a7144f6067327c3b82ea70e7c5426add9ceea4d07dc2902239bf9e049b88625eb65d014a7718f79354608cab0921782c643f0208983fffa3582e40
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp } &&
                                  ${ target.coreutils }/bin/echo &&
                                  cleanup ( ) {
                                    EXIT_CODE=${ bash-variable "?" } &&
                                      ${ target.coreutils }/bin/echo EXIT_CODE=${ bash-variable "EXIT_CODE" } &&
                                      if [ ${ bash-variable "EXIT_CODE" } == 64 ]
                                      then
                                        ${ target.coreutils }/bin/echo SINCE WE EXPECTED THE ISOLATION TO FAIL WITH EXIT CODE 64, THIS IS A SUCCESS &&
                                          exit 0
                                      else
                                        ${ target.coreutils }/bin/echo SINCE WE EXPECTED THE ISOLATION TO FAIL WITH EXIT CODE 64, THIS IS A FAILURE ${ bash-variable "EXIT_CODE" } &&
                                          exit 64
                                      fi
                                  } &&
                                  trap cleanup EXIT &&
                                  ISOLATED=${ isolated { init = scripts : builtins.elemAt scripts.scripts.sad 0 ; } }
                                '' ;
                            isolated-111 =
                              { bash-variable , hash , isolated , path , process , target , timestamp } :
                                ''
                                  # isolated
                                  # 3c9ad55147a7144f6067327c3b82ea70e7c5426add9ceea4d07dc2902239bf9e049b88625eb65d014a7718f79354608cab0921782c643f0208983fffa3582e40
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp } &&
                                  ${ target.coreutils }/bin/echo &&
                                  cleanup ( ) {
                                    EXIT_CODE=${ bash-variable "?" } &&
                                      ${ target.coreutils }/bin/echo EXIT_CODE=${ bash-variable "EXIT_CODE" } &&
                                      if [ ${ bash-variable "EXIT_CODE" } == 64 ]
                                      then
                                        ${ target.coreutils }/bin/echo SINCE WE EXPECTED THE ISOLATION TO FAIL WITH EXIT CODE 64, THIS IS A SUCCESS &&
                                          exit 0
                                      else
                                        ${ target.coreutils }/bin/echo SINCE WE EXPECTED THE ISOLATION TO FAIL WITH EXIT CODE 64, THIS IS A FAILURE ${ bash-variable "EXIT_CODE" } &&
                                          exit 64
                                      fi
                                  } &&
                                  trap cleanup EXIT &&
                                  ISOLATED=${ isolated { init = scripts : builtins.elemAt scripts.scripts.sad 0 ; release = scripts : builtins.elemAt scripts.scripts.happy 0 ; } }
                                '' ;
                          } ;
                        private =
                          { private } :
                            ''
                              # private
                              # 06df05371981a237d0ed11472fae7c94c9ac0eff1d05413516710d17b10a4fb6f4517bda4a695f02d0a73dd4db543b4653df28f5d09dab86f92ffb9b86d01e25
                              if [ "${ private }" != "82b71638-804f-4533-b6dc-2f87b7ae5afc" ]
                              then
                                exit 64
                              fi
                            '' ;
                        scripts =
                          {
                            happy =
                              [
                                (
                                  { bash-variable , hash , path , process , structure-directory , target , timestamp } :
                                    ''
                                      # script
                                      #
                                      if [ "${ bash-variable 1 }" != "${ path }" ]
                                      then
                                        ${ target.coreutils }/bin/echo "${ bash-variable 1 } != ${ path }" > ${ bash-variable 1 } &&
                                          exit 64
                                      elif [ "${ path }" != "${ structure-directory }/${ hash }" ]
                                      then
                                        ${ target.coreutils }/bin/echo "${ path } != ${ structure-directory }/${ hash }" &&
                                          exit 64
                                      else
                                        ${ target.coreutils }/bin/echo HASH='${ hash }' > ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/echo PATH='${ path }' >> ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/echo PROCESS='${ process }' >> ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }' >> ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/chmod 0400 ${ bash-variable 1 }
                                      fi                               
                                    ''
                                )
                                (
                                  { bash-variable , hash , path , process , target , structure-directory , timestamp } :
                                    ''
                                      # script
                                      #
                                      if [ "${ bash-variable 1 }" != "${ path }" ]
                                      then
                                        ${ target.coreutils }/bin/echo "${ bash-variable 1 } != ${ path }" > ${ bash-variable 1 } &&
                                          exit 64
                                      elif [ "${ path }" != "${ structure-directory }/${ hash }" ]
                                      then
                                        ${ target.coreutils }/bin/echo "${ path } != ${ structure-directory }/${ hash }" &&
                                          exit 64
                                      else
                                        ${ target.coreutils }/bin/echo HASH='${ hash }' > ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/echo PATH='${ path }' >> ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/echo PROCESS='${ process }' >> ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }' >> ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/chmod 0400 ${ bash-variable 1 }
                                      fi                               
                                    ''
                                )
                                (
                                  ''
                                    # script
                                    #
                                  ''
                                )
                              ] ;
                            sad =
                              [
                                (
                                  { bash-variable , hash , path , process , structure-directory , target , timestamp } :
                                    ''
                                      # script
                                      #
                                      if [ "${ bash-variable 1 }" != "${ path }" ]
                                      then
                                        ${ target.coreutils }/bin/echo "${ bash-variable 1 } != ${ path }" > ${ bash-variable 1 } &&
                                          exit 64
                                      elif [ "${ path }" != "${ structure-directory }/${ hash }" ]
                                      then
                                        ${ target.coreutils }/bin/echo "${ path } != ${ structure-directory }/${ hash }" &&
                                          exit 64
                                      else
                                        ${ target.coreutils }/bin/echo HASH='${ hash }' > ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/echo PATH='${ path }' >> ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/echo PROCESS='${ process }' >> ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }' >> ${ bash-variable 1 } &&
                                          ${ target.coreutils }/bin/chmod 0400 ${ bash-variable 1 }
                                      fi &&
                                      exit 65
                                    ''
                                )
                                ''
                                  exit 66
                                ''
                                ''
                                  exit 67
                                ''
                              ] ;
                          } ;
                        set =
                          { } :
                            ''
                              # set
                              # a321d8b405e3ef2604959847b36d171eebebc4a8941dc70a4784935a4fca5d5813de84dfa049f06549aa61b20848c1633ce81b675286ea8fb53db240d831c568
                            '' ;
                        simple =
                          {
                            simple-0 =
                              { hash , path , process , target , timestamp } :
                                ''
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp }
                                '' ;
                            simple-1 =
                              { hash , path , process , target , timestamp } :
                                ''
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp }
                                '' ;
                            simple-2 =
                              { bash-variable , hash , path , process , target , timestamp } :
                                ''
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } > ${ bash-variable 1 } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } >> ${ bash-variable 1 } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } >> ${ bash-variable 1 } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp } >> ${ bash-variable 1 } &&
                                  ${ target.coreutils }/bin/chmod 0400 ${ bash-variable 1 }
                                '' ;
                            simple-3 =
                              { bash-variable , hash , isolated , path , process , target , timestamp } :
                                ''
                                  ${ target.coreutils }/bin/cat ${ isolated { init = scripts : scripts.simple.simple-2 ; } } &&
                                  ${ target.coreutils }/bin/echo &&
                                  ${ target.coreutils }/bin/echo HASH='${ hash }'=${ hash } &&
                                  ${ target.coreutils }/bin/echo PATH='${ path }'=${ path } &&
                                  ${ target.coreutils }/bin/echo PROCESS='${ process }'=${ process } &&
                                  ${ target.coreutils }/bin/echo TIMESTAMP='${ timestamp }'=${ timestamp }
                                '' ;
                          } ;
                        string =
                          ''
                            # string
                            # 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99
                            # 3bafbf08882a2d10133093a1b8433f50563b93c14acd05b79028eb1d12799027241450980651994501423a66c276ae26c43b739bc65c4e16b10c3af6c202aebb
                          '' ;
                      } ; 
                    shared =
                      {
                      } ;
                    structure-directory = "/home/runner/resources" ;
                    target = pkgs ;
                  } ;
                fun =
                  fun :
                    let
                      hooks = fun ( { code } : code ) ;
                      inputs = fun ( { shell-script-bin } : shell-script-bin ) ;
                      in { devShell = pkgs.mkShell { shellHook = hooks.entrypoint ; buildInputs = [ inputs.isolated.isolated-000 inputs.isolated.isolated-001 inputs.isolated.isolated-010 inputs.isolated.isolated-011 inputs.isolated.isolated-101 inputs.isolated.isolated-111 inputs.private inputs.set inputs.simple.simple-0 inputs.simple.simple-1 inputs.simple.simple-3 inputs.string ] ; } ; } ;
                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                in shell.lib arguments fun ;
          in flake-utils.lib.eachDefaultSystem fun ;
  }

