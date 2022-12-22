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
                                  _scripts = _utils.visit
                                    {
                                      list = track : track.reduced ;
                                      set = track : track.reduced ;
                                      string = track : _utils.strip track.reduced ;
                                    } ( scripts structure ) ;
                                  structure =
                                    {
                                      pkgs = pkgs ;
                                      numbers = numbers.shared ;
                                      resources = _utils.visit
                                        {
                                          lambda = track : "${ pkgs.coreutils }/bin/echo PLACE HOLDER RESOURCES" ;
                                          list = track : track.reduced ;
                                          set = track : track.reduced ;
                                        } ( resources _scripts ) ;
                                      scripts = _scripts ;
                                      variables = variables.shared ;
                                    } ;
                                  in
                                    {
                                      hook = hook _scripts ;
                                      inputs =
                                        let
                                          scripts =
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
                                                      ${ _utils.strip track.reduced }
                                                    '' ;
                                              } _scripts ;
                                          in builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name ( _utils.strip value ) ) ( inputs scripts ) ) ;
                                    } ;
                            zero =
                              let
                                raw =
                                  {
                                    numbers =
                                      {
                                        script = [ "structure" ] ;
                                      } ;
                                    variables =
                                      {
                                        script = [ "log" ] ;
                                        shared = [ "temporary" "din" "debug" "notes" ] ;
                                      } ;
                                  } ;
                                processed =
                                  _utils.visit
                                    {
                                      list = track : builtins.foldl' ( previous : current : previous // current ) { } track.reduced ;
                                      set = track : track.reduced ;
                                      string = track : { "${ _utils.strip track.reduced }" = "" ; } ;
                                    } raw ;
				variables =
                                zero = fun processed.numbers processed.variables ;
				in fun processed.numbers processed.variables ;
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
