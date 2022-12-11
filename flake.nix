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
                        _utils = builtins.getAttr system utils.lib ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        structure =
                          _utils.try
                            (
                              seed :
                                let
                                  is-not-duplicate =
                                    _utils.visit
                                      {
                                        list = track : builtins.all ( x : x ) track.reduced ;
                                        set = track : builtins.all ( x : x ) ( builtins.attrValues track.reduced ) ;
                                        string =
                                          track :
                                            let
                                              number = builtins.toString seed ;
                                              token = builtins.hashString "sha512" number ;
                                              in builtins.replaceStrings [ number token ] [ "" "" ] track.reduced == track.reduced ;
                                      } ( builtins.getAttr "scripts" ( structure 0 ) ) ;
                                  structure =
                                    seed :
                                      let
                                        _scripts =
                                          _utils.visit
                                            {
                                              lambda = track : track.reduced ( structure seed ) ;
                                              list = track : track.reduced ;
                                              set = track : track.reduced ;
                                            } scripts ;
                                        in
                                          {
                                            pkgs = pkgs ;
                                            programs =
                                              _utils.visit
                                                {
                                                  list = track : track.reduced ;
                                                  set = track : track.reduced ;
                                                  string = track : pkgs.writeShellScriptBin "script" track.reduced ;
                                                } _scripts ;
                                            scripts = _scripts ;
                                            urandom = urandom ;
                                          } ;
                                  in
                                    {
                                      success = seed > 2 && is-not-duplicate ;
                                      value = structure seed ;
                                    }
                            ) ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name ( builtins.readFile value ) ) ( inputs structure.programs ) ) ;
                              shellHook = hook structure.scripts ;
                            }
                  ) ;
              }
      ) ;
    }
