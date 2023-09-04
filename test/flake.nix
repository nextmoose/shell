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
                                  NUMBER=$( ${ target.findutils }/bin/find $( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) -mindepth 1 -type f -exec ${ target.coreutils }/bin/cat {} \; | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e" ]
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
                                  NUMBER=$( ${ target.findutils }/bin/find $( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) -mindepth 1 -type f -exec ${ target.coreutils }/bin/cat {} \; | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "579f227f63b35cc28dc953966d2f3d64a6deeffe27a8e0a2764480009887749c7b2665dd23cebd1677d816afd47b93495771f9a5f6615f553a7a862ba5d1c732" ]
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
                                  NUMBER=$( ${ target.findutils }/bin/find $( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) -mindepth 1 -type f -exec ${ target.coreutils }/bin/cat {} \; | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "afee6f1efcd0945751a70ae68eb52f4abf74fe37c0899d4d57c2428c22b57f7e4abab1b189c010c2dc650e295bd44a56a2f2aa8418b9b7c3a01e08f662712f14" ]
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
                                  NUMBER=$( ${ target.findutils }/bin/find $( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) -mindepth 1 -type f -exec ${ target.coreutils }/bin/cat {} \; | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "652997a0290a10cdb1e921b7ee81868c3f7c6e1d49a6121dec7e8b78962503f038a3f337495766d8d11869b87b5972af753ac7c04858ba661226d0198ac88240" ]
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                       exit 64
                                  fi
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
				      # release
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
                      in { devShell = pkgs.mkShell { shellHook = hooks.entrypoint ; buildInputs = [ inputs.isolated.isolated-000 inputs.isolated.isolated-001 inputs.isolated.isolated-010 inputs.isolated.isolated-011 inputs.private inputs.set inputs.simple.simple-0 inputs.simple.simple-1 inputs.simple.simple-3 inputs.string ] ; } ; } ;
                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                in shell.lib arguments fun ;
          in flake-utils.lib.eachDefaultSystem fun ;
  }

