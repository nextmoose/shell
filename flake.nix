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
			fun = structure.scripts ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        structure =
			  let
                            scripts =
                              _utils.try
                                (
                                  seed :
                                    let
                                      unique =
				        _utils.visit
                                          {
                                            lambda =
                                              track :
                                                let
                                                  number = builtins.toString seed ;
						  string = track.reduced structure ;
                                                  token = builtins.hashString "sha512" number ;
                                                  in builtins.replaceStrings [ token number ] [ "" "" ] string == string ;
                                            list = track : builtins.all ( x : x ) track.reduced ;
                                            set = track : builtins.all ( x : x ) ( builtins.attrValues track.reduced ) ;
                                          } ( value 0 ) ;
                                      value =
                                        seed :
                                          _utils.visit
                                            {
                                              lambda =
                                                track :
                                                  let
                                                    number = builtins.toString seed ;
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
                                                        ${ _utils.strip ( track.reduced structure ) }
                                                      '' ;
                                                    token = builtins.hashString "sha512" number ;
                                                    in _utils.strips script ;
                                              list = track : track.reduced ;
                                              set = track : track.reduced ;
                                            } ( scripts structure ) ;
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
				      string = track : pkgs.writeText "script" ( _utils.strip track.reduced ) ;
				    } scripts ;
				scripts = scripts ;
                                urandom = urandom ;
                              } ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs = builtins.attrValues ( builtins.mapAttrs ( name : value : pkgs.writeShellScriptBin name value ) ( inputs fun ) ) ;
                              shellHook = hook fun ;
                            }
                  ) ;
              }
      ) ;
    }
