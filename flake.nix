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
                          let
                            in
                              {
                                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                                scripts =
                                  _utils.visitor
                                    {
                                      list = track : track.reduced ;
                                      set = track : track.reduced ;
                                      string =
                                        track :
                                          _utils.try
                                            (
                                              seed :
                                                let
                                                  script =
                                                    script :
                                                      ''
                                                        if [ ! -d ${ structure-directory } ]
                                                        then
                                                          ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                        fi &&
                                                        if [ ! -d ${ structure-directory }/logs ]
                                                        then
                                                          ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logs
                                                        fi
                                                      '' ;
                                                    token = builtins.hashString "sha512" ( builtins.toString seed ) ;
                                                  in
                                                    {
                                                      success = builtins.replaceStrings [ token ] [ "" ] track.reduced == track.reduced ;
                                                      value = pkgs.writeText "script" ( script ( utils.strip track.reduced ) )
                                                    }
					    ) ;
                                    } ;
                                urandom = urandom ;
                                utils = _utils ;
                              } ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name value ) ( inputs ( scripts structure ) ) ) ;
                              shellHook = hook ( scripts structure ) ;
                            }
                  ) ;
              }
      ) ;
    }
