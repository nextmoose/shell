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
                              list = track : builtins.concatStringsSep "" [ " [ " ( builtins.concatStringsSep "" track.reduced ) " ] " ] ;
                              set = track : builtins.concatStringsSep "" [ " { " ( builtins.concatStringsSep "" ( builtins.attrValues ( builtins.mapAttrs ( name : value : builtins.concatStringsSep "" [ " " name " = " value " ;" ] ) track.reduced ) ) ) " } " ] ;
                              path = track : builtins.concatStringsSep "" [ "\"" ( builtins.toString track.reduced ) "\"" ] ;
                              string = track : builtins.concatStringsSep "" [ "\"" track.reduced "\"" ] ;
                            } structure.scripts2 ;
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
                                            scripts2 =
                                              _utils.visit
                                                {
                                                  list = track : track.reduced ;
                                                  set = track : track.reduced ;
                                                  string = track : _utils.strip track.reduced ;
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
				    pkgs.writeShellScriptBin
				      "generate"
				      ''
					SCRIPT_DIRECTORY=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
					  cd ${ _utils.bash-variable "SCRIPT_DIRECTORY" } &&
					  ${ pkgs.nix }/bin/nix flake init &&
					  ${ pkgs.coreutils }/bin/cp ${ ./src/flake.nix } flake.nix &&
					  ${ pkgs.coreutils }/bin/echo "${ _utils.bash-variable "1" }" > hook.nix &&
					  ${ pkgs.coreutils }/bin/echo "${ _utils.bash_variable "2" }" > inputs.nix &&
				          STRUCTURE_DIRECTORY="${ _utils.bash-variable "3" }" &&
					  ${ pkgs.coreutils }/bin/touch scripts.nix &&
					  ${ pkgs.coreutils }/bin/chmod 0400 flake.nix hook.nix inputs.nix scripts.nix &&
				      ''
                                  )
                                ] ;
                              shellHook = "${ pkgs.coreutils }/bin/echo HELLO! ${ structure.token }" ;
                            }
                  ) ;
              }
      ) ;
    }
