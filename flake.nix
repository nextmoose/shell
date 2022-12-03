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
                    nixpkgs : scripts : hook : at :
                      let
                        _utils = builtins.getAttr system utils.lib ;
                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                        sed =
                          _utils.visit
                            {
                              list = track : builtins.concatStringsSep " &&" track.reduced ;
                              set = track : builtins.concatStringsSep " &&" ( builtins.attrValues track.reduced ) ;
                              string =
                                track :
                                  _utils.strip
                                    ''
                                      ${ pkgs.gnused }/bin/sed \
                                        -e "s#${ structure.loggers.note }#${ builtins.concatStringsSep "" [ "$" "{" "LOG_DIR" "}" ] }#" \
                                        -e "wscripts/${ builtins.toString track.index }" \
                                        ${ track.reduced }
                                    '' ;
                            } ;
                        structure =
                          _utils.try
                            (
                              seed :
                                let
                                  fun =
                                    seed :
                                      let
                                        loggers =
                                          {
                                            err = "/dev/stderr" ;
                                            out = "/dev/stdout" ;
                                            din = builtins.concatStringsSep "_" [ "DIN" structure-directory ] ;
                                            note = builtins.concatStringsSep "_" [ "NOTE" structure-directory ] ;
                                          } ;
                                        structure-directory = builtins.concatStringsSep "_" [ "STRUCTURE" token ] ;
                                        temporary-directory = builtins.concatStringsSep "_" [ "TEMPORARY" token ] ;
                                        token = builtins.hashString "sha512" ( builtins.toString seed ) ;
                                        in
                                          {
                                            loggers = loggers ;
                                            pkgs = pkgs ;
                                            scripts =
                                              _utils.visit
                                                {
                                                  list = track : track.reduced ;
                                                  set = track : track.reduced ;
                                                  string = track : builtins.concatStringsSep "_" [ "SCRIPT" token ( pkgs.writeText "script" ( _utils.strip track.reduced ) ) ] ;
                                                } ( scripts ( fun seed ) ) ;
                                            structure-directory = structure-directory ;
                                            temporary-directory = temporary-directory ;
                                            token = token ;
                                            utils = _utils ;
                                          } ;
                                    in
                                      {
                                        success =
                                          _utils.visit
                                            {
                                              set = track : builtins.all ( x : x ) ( builtins.attrValues track.reduced ) ;
                                              string = track : builtins.replaceStrings [ ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] [ "" ] track.reduced == track.reduced ;
                                            } ( scripts ( fun 0 ) ) ;
                                        value = ( fun seed ) ;
                                      }
                            ) ;
                        in
                          pkgs.mkShell
                            {
                              buildInputs =
			        [
			          (
				    pkgs.stdenv.mkDerivation
				      {
				        name = "generate" ;
					buildPhase = "${ pkgs.makeWrapper } ${ ./src/generate.sh } $out/bin/generate --set COREUTILS ${ pkgs.coreutils } --set MKTEMP ${ pkgs.mktemp } --set NIX ${ pkgs.nix }" ;
				      }
				  )
				] ;
                              shellHook = "${ pkgs.coreutils }/bin/echo HELLO! ${ structure.scripts.program4 }" ;
                            }
                  ) ;
              }
      ) ;
    }
