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
                    err = "/dev/stderr" ;
                    fun =
                      fun :
                        let
                          hooks = fun ( { script } : script ) ;
                          inputs = fun ( { shell-script-bin } : shell-script-bin ) ;
                          in { devShell = pkgs.mkShell { shellHook = hooks.entrypoint ; buildInputs = [ inputs.simple inputs.temporary ] ; } ; } ;
                    host = pkgs ;
                    null = "/dev/null" ;
                    out = "/dev/stdout" ;
                    scripts =
                      {
                        entrypoint =
                          { target } :
                            ''
                              ${ target.cowsay }/bin/cowsay ENTRY POINT
                            '' ;
                        git =
                          {
                            init =
                              { bash-variable , target } :
                                ''
                                  ${ target.coreutils }/bin/mkdir $( ${ target.coreutils }/bin/dirname ${ bash-variable 0 } )/temporary
                                '' ;
                            release =
                              { bash-variable , target } :
                                ''
                                  ${ target.coreutils }/bin/echo HELLO
                                '' ;
                          } ;
                        simple =
                          { target } :
                            ''
                              ${ target.cowsay }/bin/cowsay SIMPLE
                            '' ;
                        temporary =
                          { target , temporary } :
                            ''
                              ${ target.coreutils }/bin/echo ${ temporary { init = scripts : scripts.git.init ; release = scripts : scripts.git.release ; } }
                            '' ;
                      } ;
                    structure-directory = "/home/emory/formation" ;
                    target = pkgs ;
                  } ;
                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                in shell.lib arguments ;
          in flake-utils.lib.eachDefaultSystem fun ;
  }
