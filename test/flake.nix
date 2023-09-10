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
                      let
                        numbers =
                          [
                            "a"
                            "b"
                            "c"
                            "d"
                            "e"
                            "f"
                            "g"
                            "h"
                            "i"
                            "j"
                            "k"
                            "l"
                            "a"
                          ] ;
                        in
                          {
                            entrypoint =
                              { target } :
                                ''
                                  ${ target.cowsay }/bin/cowsay ENTRY POINT
                                '' ;
                            handlers =
                              let
                                gen =
                                  index :
                                    { expressions , target } :
                                      let
                                        key = builtins.hashString "sha512" ( builtins.concatStringsSep "_" [ ( builtins.toString index ) "value" ] ) ;
                                        value = builtins.hashString "sha512" ( builtins.concatStringsSep "_" [ ( builtins.toString index ) "value" ] ) ;
                                        in
                                        ''
                                          ${ target.coreutils }/bin/mkdir ${ expressions.path } &&
                                            ${ target.coreutils }/bin/echo ${ value } > ${ expressions.path }/${ key } &&
                                            ${ target.coreutils }/bin/chmod 0400 ${ expressions.path }/key
                                        '' ;
                                in builtins.genList gen ( builtins.length numbers ) ;
                            resource =
                              let
                                call =
                                  context : init : isolated : release : salt : shared :
                                    if context then isolated init release
                                    else builtins.throw "NOT IMPLEMENTED YET" ;
                                isolated =
                                  isolated : init : release :
                                    let
                                      index = ( if builtins.typeOf init == "null" then 0 else 2 ) + ( if builtins.typeOf release == "null" then 0 else 1 ) ;
                                      list =
                                        [
                                          ( isolated { } )
                                          ( isolated { init = scripts : builtins.elemAt scripts.handlers init ; } )
                                          ( isolated { release = scripts : builtins.elemAt scripts.handlers release ; } )
                                          ( isolated { init = scripts : builtins.elemAt scripts.handlers init ; release = scripts : builtins.elemAt scripts.handlers release ; } )
                                        ] ;
                                      in builtins.elemAt list index ;
                                reducer =
                                  previous : current :
                                    if builtins.any ( p : previous == p ) then builtins.throw "3b413367-585d-45be-b065-e03e45a9412a"
                                    else builtins.concatLists [ previous [ current ] ] ;
                                script = { target , util } : "${ target.coreutils }/bin/echo hI '${ util.bash-variable "1" }'" ;
                                test =
                                  context : init : release : salt : index : { isolated , shared , target } :
                                    ''
                                      cleanup ( ) {
                                        ${ target.coreutils }/bin/echo 2
                                      } &&
                                        trap cleanup EXIT
                                          ${ target.coreutils }/bin/echo 1
                                    '' ;
                                tests =
                                  [
                                    ( test true null null null )
                                  ] ;
                                verified = builtins.foldl' reducer [ ] numbers ;
                                in builtins.listToAttrs ( builtins.genList ( index : { name = builtins.concatStringsSep "-" [ "resource" ( builtins.toString index ) ] ; value = builtins.elemAt tests index index ; } ) ( builtins.length tests ) ) ;
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
                      path =
                        [
                          inputs.resource.resource-0
                        ] ;
                      in { devShell = pkgs.mkShell { shellHook = hooks.entrypoint ; buildInputs = path ; } ; } ;
                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                in shell.lib arguments fun ;
          in flake-utils.lib.eachDefaultSystem fun ;
  }

