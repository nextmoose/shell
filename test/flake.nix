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
                        bash-variable =
                          {
                            bash-variable-0 =
                              { bash-variable , target } :
                                ''
                                  if [ '${ bash-variable 1 }' != '${ builtins.concatStringsSep "" [ "$" "{" "1" "}" ] }' ]
                                  then
                                    ${ target.coreutils }/bin/echo bash-variable fails on numbers &&
                                      exit 64
                                  fi
                                '' ;
                            bash-variable-1 =
                              { bash-variable , target } :
                                ''
                                  if [ '${ bash-variable "1" }' != '${ builtins.concatStringsSep "" [ "$" "{" "1" "}" ] }' ]
                                  then
                                    ${ target.coreutils }/bin/echo bash-variable fails on strings &&
                                      exit 64
                                  fi
                                '' ;
                          } ;
                        entrypoint =
                          { target } :
                            ''
                              ${ target.cowsay }/bin/cowsay ENTRY POINT
                            '' ;
			hash =
			  {
			    hash-0 =
			      { hash , target } :
			        ''
				  if [ -z "${ hash }" ]
				  then
				    ${ target.coreutils }/bin/echo hash IS EMPTY WHICH IS CORRECT &&
				      exit 0
				  else
				    ${ target.coreutils }/bin/echo hash IS NOT EMPTY &&
				      ${ target.coreutils }/bin/echo ${ hash } &&
				      exit 64
				  fi
				'' ;
			  } ;
                        isolated =
                          {
                            isolated-000 =
                              { bash-variable , isolated , target } :
                                ''
                                  ISOLATED=${ isolated { } } &&
                                  DIRECTORY=$( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) &&
                                  NUMBER=$( ${ target.findutils }/bin/find $( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) -mindepth 1 -type f | sort | while read FILE ; do ${ target.coreutils }/bin/cat ${ bash-variable "FILE" } ; done | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e" ]
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                       exit 64
                                  fi
                                '' ;
                            isolated-0001 =
                              { bash-variable , isolated , target } :
                                ''
                                  ISOLATED=${ isolated { init = scripts : builtins.elemAt scripts.scripts.happy 0 ; } } &&
                                  DIRECTORY=$( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) &&
                                  NUMBER=$( ${ target.findutils }/bin/find $( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) -mindepth 1 -type f | sort | while read FILE ; do ${ target.coreutils }/bin/cat ${ bash-variable "FILE" } ; done | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "f7347680f1489cd2bcb617c8cc61d3bfeebec1230979552940d1f2959d4ec94b57c9e4825b6e09b6f4323c97e4ed12d2c3810a614f083bfc1f6c9a62bfd261e2" ]
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                       exit 64
                                  fi
                                '' ;
                            isolated-0010 =
                              { bash-variable , isolated , target } :
                                ''
                                  ISOLATED=${ isolated { release = scripts : builtins.elemAt scripts.scripts.happy 1 ; } } &&
                                  DIRECTORY=$( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) &&
                                  NUMBER=$( ${ target.findutils }/bin/find $( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) -mindepth 1 -type f | sort | while read FILE ; do ${ target.coreutils }/bin/cat ${ bash-variable "FILE" } ; done | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "686c8cc840d960a2a1452f4afa96f5e0f8a81a0409ed3c856e5721e869c5ddb7dbd1523d63ca3583c5eb6695128b51bfb56dc2bd6fff21086700d80ea15a7b9a" ]
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                       exit 64
                                  fi
                                '' ;
                            isolated-0011 =
                              { bash-variable , isolated , target } :
                                ''
                                  ISOLATED=${ isolated { init = scripts : builtins.elemAt scripts.scripts.happy 0 ; release = scripts : builtins.elemAt scripts.scripts.happy 1 ; } } &&
                                  DIRECTORY=$( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) &&
                                  NUMBER=$( ${ target.findutils }/bin/find $( ${ target.coreutils }/bin/dirname ${ bash-variable "ISOLATED" } ) -mindepth 1 -type f | sort | while read FILE ; do ${ target.coreutils }/bin/cat ${ bash-variable "FILE" } ; done | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                  ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                  if [ ${ bash-variable "NUMBER" } != "b580ff8523d9289913f091e6d285d4f0a8699e70f06950fb157c38e4d35006f90c8b5336993cbfd38af94c1a8c2df594edd13efd95031e80459abfd96b018da7" ]
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                       exit 64
                                  fi
                                '' ;
                            isolated-0101 =
                              { bash-variable , isolated , structure-directory , target } :
                                ''
                                  if ${ isolated { init = scripts : builtins.elemAt scripts.scripts.sad 0 ; } }
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED COMMAND WAS MEANT TO FAIL &&
                                      exit 64
                                  else
                                    EXIT_CODE=${ bash-variable "?" } &&
                                      if [ ${ bash-variable "EXIT_CODE" } == 64 ]
                                      then
                                        ${ target.findutils }/bin/find ${ structure-directory } -mindepth 1 -maxdepth 1 -type d | while read DIRECTORY
                                        do
                                          NUMBER=$( ${ target.findutils }/bin/find ${ bash-variable "DIRECTORY" } -mindepth 1 -type f | sort | while read FILE ; do ${ target.coreutils }/bin/cat ${ bash-variable "FILE" } ; done | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                          ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                          if [ ${ bash-variable "NUMBER" } == "4f355c5c1e0e96e03175ba6b8e4119539daf3dbccabc1bcd27e80a134f7fc25b39ea582b9c6200f70aac570f5b21954320d0b83dd0b36b5ba0c6021e6029058e" ]
                                          then
                                            ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY MATCHES EXPECTED &&
                                              exit 0
                                          else
                                            ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                               exit 64
                                          fi
                                        done
                                      else
                                        ${ target.coreutils }/bin/echo EXIT CODE=${ bash-variable "EXIT_CODE" }
                                          exit 64
                                      fi
                                  fi
                                '' ;
                            isolated-0111 =
                              { bash-variable , isolated , structure-directory , target } :
                                ''
                                  if ${ isolated { init = scripts : builtins.elemAt scripts.scripts.sad 0 ; release = scripts : builtins.elemAt scripts.scripts.happy 1 ; } }
                                  then
                                    ${ target.coreutils }/bin/echo THE ISOLATED COMMAND WAS MEANT TO FAIL &&
                                      exit 64
                                  else
                                    EXIT_CODE=${ bash-variable "?" } &&
                                      if [ ${ bash-variable "EXIT_CODE" } == 64 ]
                                      then
                                        ${ target.findutils }/bin/find ${ structure-directory } -mindepth 1 -maxdepth 1 -type d | while read DIRECTORY
                                        do
                                          NUMBER=$( ${ target.findutils }/bin/find ${ bash-variable "DIRECTORY" } -mindepth 1 -type f | sort | while read FILE ; do ${ target.coreutils }/bin/cat ${ bash-variable "FILE" } ; done | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
                                          ${ target.coreutils }/bin/echo ${ bash-variable "NUMBER" } &&
                                          if [ ${ bash-variable "NUMBER" } == "bd2134ca09ab522d7f61674069968818a9db5d40e081ee3ef9ea2d8f23d0d9e00971f97740c94dc585273532fe11f0539b69869c28ef09ba2942f82cba21d6d6" ]
                                          then
                                            ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY MATCHES EXPECTED &&
                                              exit 0
                                          else
                                            ${ target.coreutils }/bin/echo THE ISOLATED DIRECTORY IS DIFFERENT THAN EXPECTED &&
                                               exit 64
                                          fi
                                        done
                                      else
                                        ${ target.coreutils }/bin/echo EXIT CODE=${ bash-variable "EXIT_CODE" }
                                          exit 64
                                      fi
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
                                ''
                                  exit 65
                                ''
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
                      in { devShell = pkgs.mkShell { shellHook = hooks.entrypoint ; buildInputs = [ inputs.bash-variable.bash-variable-0 inputs.bash-variable.bash-variable-1 inputs.hash.hash-0 inputs.isolated.isolated-0000 inputs.isolated.isolated-0001 inputs.isolated.isolated-0010 inputs.isolated.isolated-0011 inputs.isolated.isolated-0101 inputs.isolated.isolated-0111 inputs.private inputs.set inputs.simple.simple-0 inputs.simple.simple-1 inputs.simple.simple-3 inputs.string ] ; } ; } ;
                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                in shell.lib arguments fun ;
          in flake-utils.lib.eachDefaultSystem fun ;
  }

