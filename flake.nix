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
                            _scripts =
                              _utils.try
                                (
                                  seed :
                                    let
                                      unique = true ;
                                      unique2 =
                                        _utils.visit
                                          {
                                            list = track : builtins.all ( x : x ) track.reduced ;
                                            set = track : builtins.all ( x : x ) ( builtins.attrValues track.reduced ) ;
                                            string =
                                              track :
                                                let
                                                  number = builtins.toString seed ;
                                                  token = builtins.hashString "sha512" number ;
                                                  in builtins.replaceStrings [ token number ] [ "" "" ] track.reduced == track.reduced ;
                                          } ( value 0 ) ;
                                      value =
                                        seed :
                                          _utils.visit
                                            {
                                              lambda =
                                                track :
                                                  let
                                                    number = builtins.toString seed ;
                                                    string = track.reduced structure ;
                                                    token = builtins.hashString "sha512" number ;
                                                    in _utils.strip string ;
                                              list = track : track.reduced ;
                                              set = track : track.reduced ;
                                            } scripts ;
                                      in
                                        {
                                          success = seed > 2 && unique ;
                                          value = value seed ;
                                        }
                                  ) ;
                            in
                              {
                                pkgs = pkgs ;
                                programs =
                                  _utils.visit
                                    {
                                      list = track : track.reduced ;
                                      set = track : track.reduced ;
                                      string =
                                        track :
                                          let
					    token = "HELLO" ;
					    number = "50" ;
                                            script =
                                              ''
                                                if [ ! -d ${ structure-directory } ]
                                                then
                                                  ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                fi &&
                                                if [ ! -d ${ structure-directory }/logs ]
                                                then
                                                  ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/logs
                                                fi &&
                                                LOG_${ token }=$( ${ pkgs.mktemp }/bin/mktemp --directory ${ structure-directory }/logs/XXXXXXXX ) &&
                                                exec ${ number } <> ${ _utils.bash-variable ( builtins.concatStringsSep "_" [ "LOG" token ] ) }/lock &&
                                                ${ pkgs.flock }/bin/flock --nonblock ${ number } &&
                                                ${ _utils.strip track.reduced }
                                              '' ;
                                            in "${ pkgs.writeShellScriptBin "script" script }/bin/script" ;
                                    } _scripts ;
                                scripts = _scripts ;
                                urandom = urandom ;
                              } ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name value ) ( inputs structure.programs ) ) ;
                              shellHook = hook structure.scripts ;
                            }
                  ) ;
              }
      ) ;
    }
