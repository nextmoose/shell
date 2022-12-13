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
                    nixpkgs : at : urandom : structure-directory : scripts : hook : inputs :
                      let
                        _scripts =
                          _utils.visit
                            {
                              lambda = track : track.reduced ( structures.one ( track.reduced structures.zero ) ) ;
                              list = track : track.reduced ;
                              set = track : track.reduced ;
                            } scripts ;
                        _utils = builtins.getAttr system utils.lib ;
                        derivations =
                          _utils.visit
                            {
                              lambda = track :
                                let
                                  numbers = structures.numbers zero ;
                                  variables = structures.variables zero ;
                                  string = track.reduced ( structures.one zero ) ;
				  zero = track.reduced structures.zero ;
                                  in builtins.trace string ( structures.process-with string numbers variables ) ;
                              list = track : track.reduced ;
                              set = track : track.reduced ;
                            } scripts ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        structures =
                          let
                            base =
                              {
                                numbers = [ "structure" "logs" "log" "stderr" "temporaries" "temporary" ] ;
                                variables = [ "log" "stdout" "stderr" "din" "debug" "notes" "temporary" ] ;
                              } ;
                            generator =
                              numbers : variables :
                                let
                                  commands =
                                    _utils.visit
                                      {
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        string = track : "${ pkgs.writeShellScriptBin "command" track.reduced }/bin/command" ;
                                      } procedures ;     
                                  procedures =
                                    _utils.visit
                                      {
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        string = track : process track.reduced ;
                                      } _scripts ;
                                  in
                                    {
                                      commands = commands ;
                                      numbers = numbers ;
                                      pkgs = pkgs ;
                                      variables = variables ;
                                    } ;
                            numbers = string : let r = reducers string ; in builtins.foldl' r.numbers { } base.numbers ;
                            one = string : generator ( numbers string ) ( variables string ) ;
			    process =
			      string :
                                let
                                  n = numbers string ;
                                  v = variables string ;
                                  in process-with string n v ;
                            process-with =
                              string : numbers : variables :
			        let
                                  temporary =
                                    ''
                                      if [ ! -d ${ structure-directory }/temporary ]
                                      then
                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                      fi &&
                                      exec ${ numbers.temporaries }<>${ structure-directory }/temporary/lock &&
                                      ${ pkgs.flock }/bin/flock -s ${ numbers.temporaries } &&
                                      ${ v.temporary }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                      exec ${ numbers.temporary }<>${ _utils.bash-variable variables.temporary }/lock &&
                                      ${ pkgs.flock }/bin/flock -n ${ numbers.temporary }
                                    '' ;
				  in
                                    ''
                                      if [ ! -d ${ structure-directory } ]
                                      then
                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                      fi &&
                                      exec ${ numbers.structure }<>${ structure-directory }/lock &&
                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure } &&
                                      if [ ! -d ${ structure-directory }/logs ]
                                      then
                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logs
                                      fi &&
                                      exec ${ numbers.logs }<>${ structure-directory }/logs/lock &&
                                      ${ pkgs.flock }/bin/flock -s ${ numbers.logs } &&
                                      ${ variables.log }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/logs/XXXXXXXX ) &&
                                      exec ${ numbers.log }<>${ _utils.bash-variable variables.log }/lock &&
                                      ${ pkgs.flock }/bin/flock -n ${ numbers.log } &&
                                      ${ if builtins.replaceStrings [ variables.temporary ] [ "" ] string == string then "${ pkgs.coreutils }/bin/true" else temporary } &&
				      # ${ variables.temporary }
				      # ${ numbers.temporary }
                                      ${ pkgs.writeShellScriptBin "script" string }/bin/script \
                                        > >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable variables.log }/out 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stdout" ) \
                                        2> >( ${ pkgs.moreutils }/bin/pee "${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S > ${ _utils.bash-variable variables.log }/err 2> /dev/null" "${ pkgs.coreutils }/bin/tee > /dev/stderr" )
                                  '' ;
                            reducers =
                              string :
                                {
                                  numbers =
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
                                                      is-not-duplicate = builtins.all ( p : p != number ) ( builtins.attrValues previous ) ;
                                                      is-not-in-string = builtins.replaceStrings [ number ] [ "" ] string == string ;
                                                      is-not-small = seed > 2 ;
                                                      in is-not-duplicate && is-not-in-string && is-not-small ;
                                                      value = previous // { "${ current }" = number ; } ;
                                                }
                                        ) ;
                                  variables =
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
                                                      is-not-duplicate = builtins.all ( p : p != token ) ( builtins.attrValues previous ) ;
                                                      is-not-in-string = builtins.replaceStrings [ token ] [ "" ] string == string ;
                                                      in is-not-duplicate && is-not-in-string ;
                                                      value = previous // { "${ current }" = token ; } ;
                                                }
                                        ) ;
                                } ;
                            variables = string : let r = reducers string ; in builtins.foldl' r.variables { } base.variables ;
                            zero =
                                let
                                   attrs = src : builtins.listToAttrs ( builtins.map mapper src ) ;
                                   mapper = item : { name = item; value = "" ; } ;
                                   in generator ( attrs base.numbers ) ( attrs base.variables ) ;
                            in
                              {
                                generator = generator ;
                                numbers = numbers ;
                                one = one ;
                                process = process ;
                                variables = variables ;
                                zero = zero ;
                              } ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name value ) ( inputs derivations ) ) ;
                              shellHook = hook _scripts ;
                            }
                  ) ;
              }
      ) ;
    }
