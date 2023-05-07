 {
    inputs =
      {
        bash-variable.url = "/home/emory/projects/5juNXfpb" ;
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843" ;
        scripts.url = "/home/emory/projects/61EJI0cs" ;
        strip.url = "/home/emory/projects/0TFnR2fJ" ;
        try.url = "/home/emory/projects/0gG3HgHu" ;
        unique.url = "/home/emory/projects/Rjgo3R5c" ;
        visit.url = "/home/emory/projects/wHpYNJk8" ;
      } ;
    outputs =
      { bash-variable , flake-utils , nixpkgs , self , scripts , strip , try , unique , visit } :
        {
          lib =
            let
              _ =
                {
                  bash-variable = bash-variable ;
                  flake-utils = flake-utils ;
                  nixpkgs = nixpkgs ;
                  scripts = scripts ;
                  strip = strip ;
                  unique = unique ;
                } ;
              in
                {
                  bash-variable ? _.bash-variable ,
                  flake-utils ? _.flake-utils ,
                  hook ,
                  inputs ,
                  nixpkgs ? _.nixpkgs ,
                  null ? "/dev/null" ,
                  resources ,
                  scripts ? _.scripts ,
                  strip ? _.strip ,
                  structure-directory ,
                  unique ? _.unique
                } :
                  flake-utils.lib.eachDefaultSystem
                    (
                      system :
                        {
                          devShell =
                            let
                              _scripts =
                                fun : global :
                                  let
                                    lambda =
                                      track :
                                        let
                                          local =
                                            unique.lib
                                              { }
                                              {
                                                numbers = { structure-directory = false ; temporary-directory = false ; temporary-dir = false ; log-dir = false ; } ;
                                                uuid = true ;
                                                variables = { structure-directory = true ; temporary-directory = true ; temporary-dir = true ; log-directory = true ; log-dir = true ; } ;
                                              }
                                              ( script )
                                              (
                                                token :
                                                  let
                                                    list = track : builtins.all ( r : r ) track.reduced ;
                                                    set = track : builtins.all ( r : r ) ( builtins.attrValues track.reduced ) ;
                                                    string = track : builtins.replaceStrings [ token ] [ "" ] track.reduced == track.reduced ;
                                                    undefined = track : track.throw "d3862f34-ce04-4c17-9120-f4f688045b86" ;
                                                    in visit.lib { list = list ; set = set ; string = string ; undefined = undefined ; }
                                              ) ;
                                          program =
                                            ''
                                              # ${ global.uuid }
                                              
                                              # ${ builtins.toString track.index }
                                              # ${ track.qualified-name }

                                              ${ setup }
                                              
                                              exec ${ pkgs.writeShellScript track.simple-name ( strip.lib { } ( script local ) ) }
                                            '' ;
                                          script = local : track.reduced ( structure local ) ;
                                          setup =
                                            let
                                              elements =
                                                {
                                                  no-temporary =
                                                    ''
                                                      # temporary

                                                      # log

                                                      # resource
                                                    '' ;
                                                  yes-temporary =
                                                    ''
                                                      # temporary
                                                      if [ ! -d ${ structure-directory } ]
                                                      then
                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                      fi &&
                                                      exec ${ local.numbers.structure-directory }<>${ structure-directory }/lock &&
                                                      ${ pkgs.flock }/bin/flock -s ${ local.numbers.structure-directory }
                                                      if [ ! -d ${ structure-directory }/temporary ]
                                                      then
                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                                      fi &&
                                                      exec ${ local.numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                                                      ${ pkgs.flock }/bin/flock -s ${ local.numbers.temporary-directory } &&
                                                      export ${ local.variables.temporary-dir }=$( ${ pkgs.coreutils }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                                      exec ${ local.numbers.temporary-dir }<>${ bash-variable.lib { } local.variables.temporary-dir }/lock &&
                                                      ${ pkgs.flock }/bin/flock ${ local.numbers.temporary-dir } &&

                                                      # log

                                                      # resource
                                                    '' ;
                                                } ;
                                                temporary = if builtins.replaceStrings [ local.variables.temporary-dir ] [ "" ] ( script local ) == ( script local ) then "no-temporary" else "yes-temporary" ;
                                              in builtins.getAttr temporary elements ;
                                          structure =
                                            local :
                                              {
                                                commands = _scripts ( script : program : simple-name : pkgs.writeShellScript simple-name ( strip.lib { } program ) ) global ;
                                                dev =
                                                  {
                                                    null = null ;
                                                  } ;
                                                pkgs = pkgs ;
                                                temporary = bash-variable.lib { } local.variables.temporary-dir ;
                                                tools =
                                                  {
                                                    temporary =
                                                      {
                                                        dir =
                                                          let
                                                            directory =
                                                              ''
                                                                exec ${ local.numbers.temporary-dir }<>${ bash-variable.lib { } 1 }/lock &&
                                                                ${ pkgs.flock }/bin/flock -n ${ local.numbers.temporary-dir } &&
                                                                ${ pkgs.findutils }/bin/find ${ bash-variable.lib { } 1 } -mindepth 1 -type f -exec ${ pkgs.coreutils }/bin/shred --force --remove {} \; &&
                                                                ${ pkgs.coreutils }/bin/rm --recursive --force ${ bash-variable.lib { } 1 }
                                                              '' ;
                                                            script =
                                                              ''
                                                                if [ -d ${ structure-directory }/temporary ]
                                                                then
                                                                  exec ${ local.numbers.structure-directory }<>${ structure-directory }/lock &&
                                                                  ${ pkgs.flock }/bin/flock -s ${ local.numbers.structure-directory } &&
                                                                  if [ -d ${ structure-directory }/temporary ]
                                                                  then
                                                                    exec ${ local.numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                                                                    ${ pkgs.flock }/bin/flock -s ${ local.numbers.temporary-directory } &&
                                                                    ${ pkgs.findutils }/bin/find \
                                                                      ${ structure-directory }/temporary \
								      -mindepth 1 \
								      -maxdepth 1 \
                                                                      -name "????????" \
                                                                      -type d \
                                                                      -exec ${ pkgs.writeShellScript "directory" ( strip.lib { } directory ) } {} \;
                                                                  fi
                                                                fi
                                                              '' ;
                                                            in pkgs.writeShellScript "delete" ( strip.lib { } script ) ;
						        directory =
							  let
							    script =
							      ''
							        if [ -d ${ structure-directory }/temporary ]
								then
								  exec ${ local.numbers.structure-directory }<>${ structure-directory }/lock &&
								  ${ pkgs.flock }/bin/flock ${ local.numbers.structure-directory } &&
								  ${ pkgs.findutils }/bin/find ${ structure-directory }/temporary -type f -exec ${ pkgs.coreutils }/bin/shred --force --remove {} \; &&
								  ${ pkgs.coreutils }/bin/rm --recursive --force ${ structure-directory }/temporary
								fi
							      '' ;
							    in pkgs.writeShellScript "directory" ( strip.lib { } script ) ;
                                                      } ;
                                                  } ;
                                                uuid = local.uuid ;
                                              } ;
                                          in fun ( script local ) program track.simple-name ;
                                  list = track : track.reduced ;
                                  set = track : track.reduced ;
                                  undefined = track : track.throw "73a2950b-be72-403b-afc1-47fd036c824f" ;
                                  in visit.lib { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } scripts.lib ;
                              global =
                                unique.lib
                                  { }
                                  {
                                    numbers = { structure = false ; } ;
                                    variables = { salt = true ; } ;
                                    uuid = true ;
                                  }
                                  ( _scripts ( script : program : simple-name : program ) )
                                  (
                                    token :
                                      let
                                        list = track : builtins.all ( i : i ) track.reduced ;
                                        set = track : builtins.all ( i : i ) ( builtins.attrValues track.reduced ) ;
                                        string = track : builtins.replaceStrings [ token ] [ "" ] track.reduced == track.reduced ;
                                        undefined = track : track.throw "11dc6015-b995-4972-a7fb-cd9902ae08c2" ;
                                        in visit.lib { list = list ; set = set ; string = string ; undefined = undefined ; }
                                  ) ;
                              pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                                in pkgs.mkShell
                                  {
                                    buildInputs = inputs ( _scripts ( script : program : simple-name : pkgs.writeShellScriptBin simple-name ( strip.lib { } program ) ) global ) ;
                                    shellHook = hook ( _scripts ( script : program : simple-name : script ) global ) ;
                                  } ;
                        }
                    ) ;
        } ;
  }