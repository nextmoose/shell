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
                              lambda =
                                track :
                                  let
                                    base =
                                      {
                                        numbers = [ "structure" "logs" "log" "stderr" ] ;
                                        variables = [ "structure" "stdout" "stderr" "din" "debug" "notes" "temporary" ] ;
                                      } ;
                                    string = track.reduced structures.one ;
                                    in string ;
                            list = track : track.reduced ;
                            set = track : track.reduced ;
                          } scripts ;
                        _utils = builtins.getAttr system utils.lib ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
			structures =
			  let
                            base =
                              {
                                numbers = [ "structure" "logs" "log" "stderr" ] ;
                                variables = [ "structure" "stdout" "stderr" "din" "debug" "notes" "temporary" ] ;
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
                                        string =
                                          track :
                                            ''
                                              if [ ! -d ${ structure-directory } ]
                                              then
                                                ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                              fi &&
                                              exec ${ numbers.structure }<>${ structure-directory }/lock &&
                                              ${ pkgs.flock } -s ${ numbers.structure } &&
                                              ${ pkgs.writeShellScriptBin "script" track.reduced }/bin/script
                                            '' ;
                                        } _scripts ;
                                        in
                                          {
                                            commands = commands ;
                                            numbers = numbers ;
                                            pkgs = pkgs ;
                                            variables = variables ;
                                          } ;
                            one =
                              let
                                numbers = builtins.foldl' reducers.numbers { } base.numbers ;
                                reducers =
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
                                                token = builtins.hashString "sha512" ( builtins.toString seed ) ;
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
                                string = track.reduced structures.zero ;
                                variables = builtins.foldl reducers.variables { } base.variables ;
                                in generator numbers variables ;
                            zero =
                                let
                                   attrs = src : builtins.listToAttrs ( builtins.map mapper src ) ;
                                   mapper = item : { name = item; value = "" ; } ;
                                   in generator ( attrs base.numbers ) ( attrs base.variables ) ;
			    in
			      {
			        generator = generator ;
				one = one ;
				zero = zero ;
			      } ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = [ ];
                              shellHook = hook _scripts ;
                            }
                  ) ;
              }
      ) ;
    }
