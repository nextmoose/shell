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
		    private = "954428b3-8ec0-4940-9806-f1161d153320" ;
                    scripts =
                      {
                        entrypoint =
                          { target } :
                            ''
                              ${ target.cowsay }/bin/cowsay ENTRY POINT
                            '' ;
			init =
			  { bash-variable , target } :
			    ''
			      ${ target.coreutils }/bin/mkdir ${ bash-variable 1 }
			    '' ;
                        isolated =
                          { bash-variable , isolated , target } :
                            ''
                              ISOLATED_DIRECTORY=${ isolated { init = scripts : scripts.init ; } } &&
			      ${ target.coreutils }/bin/echo "${ bash-variable "ISOLATED_DIRECTORY" }" &&
			      cd ${ bash-variable "ISOLATED_DIRECTORY" } &&
			      ${ target.bashInteractiveFHS }/bin/bash
                            '' ;
			private =
			  { private , target } :
			    ''
			      ${ target.coreutils }/bin/echo ${ private }
			    '' ;
			queer =
			  { target } :
			    ''
			      ${ target.coreutils }/bin/echo HI
			    '' ;
                        simple =
                          { hash , target , shared , shell-script-bins , timestamp } :
                            ''
                              ${ target.cowsay }/bin/cowsay SIMPLE ${ timestamp }
			      ${ target.coreutils }/bin/sleep 10s &&
			      ${ target.coreutils }/bin/echo ${ timestamp } &&
			      ${ target.coreutils }/bin/echo '${ hash }' &&
			      ${ target.coreutils }/bin/echo ${ shared.temporary-1 } &&
			      ${ target.coreutils }/bin/echo ${ shell-script-bins.queer }
                            '' ;
                      } ;
		    shared =
		      {
		        temporary-1 = resource : resource { init = scripts : scripts.init ; } ;
		        temporary-2 = resource : resource { init = scripts : scripts.init ; } ;
		      } ;
                    structure-directory = "/home/emory/formation" ;
                    target = pkgs ;
                  } ;
                fun =
                  fun :
                    let
                      hooks = fun ( { code } : code ) ;
                      inputs = fun ( { shell-script-bin } : shell-script-bin ) ;
                      in { devShell = pkgs.mkShell { shellHook = hooks.entrypoint ; buildInputs = [ inputs.isolated inputs.simple ] ; } ; } ;
                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                in shell.lib arguments fun ;
          in flake-utils.lib.eachDefaultSystem fun ;
  }

