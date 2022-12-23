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
                                      } ( scripts structure ) ;
                                  structure =
                                    {
                                      command =
                                        _utils.visit
                                          {
                                            list = track : track.reduced ;
                                            set = track : track.reduced ;
                                            string = track : "${ pkgs.writeShellScriptBin "command" }/bin/command" ;
                                          } _scripts ;
                                      pkgs = pkgs ;
                                      numbers = numbers.shared ;
                                      resources = _utils.visit
                                        {
                                          lambda = track : "${ pkgs.coreutils }/bin/echo PLACE HOLDER RESOURCES" ;
                                          list = track : track.reduced ;
                                          set = track : track.reduced ;
                                        } ( resources _scripts ) ;
                                      urandom = urandom ;
                                      utils = _utils ;
                                      variables = variables.shared ;
                                    } ;
                                  output =
                                    name : variable : string :
                                      if
                                        builtins.replaceStrings [ variable ] [ "" ] string == string then "# ${ name } 1"
                                        else
					  _utils.strip
					    ''
					      export ${ variable }="${ pkgs.moreutils }/bin/tee \">( ${ pkgs.moreutils }/bin/ts %Y-%m-%d-%H-%M-%S 2> /dev/null )\" \"${ pkgs.coreutils }/bin/tee > /dev/stdout\""
					    '' ;
                                  programs =
                                    _utils.visit
                                      {
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        string =
                                          track :
                                            ''
                                              if [ -d ${ structure-directory } ]
                                              then
                                                ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                              fi &&
                                              exec ${ numbers.script.structure }<>${ structure-directory }/lock &&
                                              ${ pkgs.flock }/bin/flock -s ${ numbers.script.structure } &&
                                              if [ -d ${ structure-directory }/logs ]
                                              then
                                                ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logs
                                              fi &&
                                              exec ${ numbers.script.logs }<>${structure-directory }/logs/lock &&
                                              ${ pkgs.flock }/bin/flock -s ${ numbers.script.logs } &&
                                              export ${ variables.script.log }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/logs/XXXXXXXX ) &&
                                              exec ${ numbers.script.log }<>${ _utils.bash-variable variables.script.log }/lock &&
                                              ${ pkgs.flock }/bin/flock ${ numbers.script.log } &&
                                              ${ track.reduced }
                                            '' ;
                                      } _scripts ;
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
                                                                } zero.scripts ;
                                                            is-unique = builtins.all ( p : p != seed ) previous ;
                                                            in is-big && is-not-in-zero && is-unique ;
                                                        value = builtins.concatLists [ previous [ number ] ] ;
                                                      }
                                              ) ;
                                        in builtins.foldl' reducer [ ] indexed ;
                                    in
                                      _utils.visit
                                        {
                                          list = track : builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                          set = track : track.reduced ;
                                          string = track : { "${ track.reduced }" = builtins.elemAt seeded track.index ; } ;
                                        } raw.numbers ;
                                raw =
                                  {
                                    numbers =
                                      {
                                        script = [ "structure" "logs" "log" ] ;
                                      } ;
                                    variables =
                                      {
                                        script = [ "log" ] ;
                                        shared = [ "temporary" "din" "debug" "notes" ] ;
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
                                                                } zero.scripts ;
                                                            is-unique = builtins.all ( p : p != seed ) previous ;
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
                                        } raw.variables ;
                                zero =
                                  let
                                    processed =
                                      _utils.visit
                                        {
                                          list = track : builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                          set = track : track.reduced ;
                                          string = track : { "${ _utils.strip track.reduced }" = "" ; } ;
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
