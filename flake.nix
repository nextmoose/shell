  {
    inputs =
      {
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843"  ;
        strip.url = "/home/emory/projects/0TFnR2fJ" ;
        unique.url = "/home/emory/projects/Rjgo3R5c" ;
        visit.url = "/home/emory/projects/wHpYNJk8" ;
      } ;
    outputs =
      { flake-utils , nixpkgs , self , strip , unique , visit } :
        {
          lib =
            let
              _ =
                {
                  nixpkgs = nixpkgs ;
                  strip = strip.lib { } ;
                  unique = unique.lib { } ;
                  visit = visit.lib { } ;
                } ;
              in
                { hook ? null , inputs ? null , knull ? "/dev/null" , nixpkgs ? _.nixpkgs , strip ? _.strip , unique ? _.unique , visit ? _.visit } :
                  flake-utils.lib.eachDefaultSystem
                    (
                      system :
                        {
                          devShell =
                            let
                              buildInputs =
                                let
                                  lambda = track : { buildInputs = track.reduced ( scripts ( { shell-script-bin } : shell-script-bin ) ) ; } ;
                                  null = track : { } ;
                                  undefined = track : track.throw "11d8d120-d631-4fec-9229-a5162062352b" ;
                                  in visit { lambda = lambda ; null = null ; undefined = undefined ; } inputs ;
                              invoke = fun : args : fun ( builtins.intersectAttrs ( builtins.functionArgs fun ) args ) ;
                              pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                              scripts =
                                fun :
                                  let
                                    lambda =
                                      track :
                                        let
                                          local =
                                            unique
                                              {
					        numbers = { structure-directory = tokenizers.number ; temporary-directory = tokenizers.number ; temporary-dir = tokenizers.number ; } ;
					        variables = { temporary-dir = tokenizers.variable ; } ;			    
					        uuid = tokenizers.uuid ;
					      }
                                              script-fun
                                              (
                                                token :
                                                  let
                                                    list = track : builtins.all ( i : i ) track.reduced ;
                                                    set = track : builtins.all ( i : i ) ( builtins.attrValues track.reduced ) ;
                                                    string = track : builtins.replaceStrings [ token ] [ "" ] track.reduced == track.reduced ;
                                                    undefined = track : track.throw "053c849b-bdd2-40b4-b7f2-1b91e6ee3357" ;
                                                    in visit { list = list ; set = set ; string = string ; undefined = undefined ; } 
                                              ) ;
                                          program =
                                            let
                                              scripts = import ./scripts.nix ;
                                              in scripts.script { script = script ; strip = strip ; track = track ; writeShellScript = pkgs.writeShellScript ; } ;
                                          shell-script-bin = pkgs.writeShellScriptBin track.simple-name program ;
                                          shell-script = pkgs.writeShellScript track.simple-name script ;
                                          script = strip ( script-fun local ) ;
                                          script-fun = local : invoke track.reduced ( structure local ) ;
                                          structure = local : pkgs // { dev = { null = knull ; } ; uuid = local.uuid ; } ;
                                          in invoke fun { script = script ; shell-script-bin = shell-script-bin ; } ;
                                    list = track : track.reduced ;
                                    set = track : track.reduced ;
                                    undefined = track : track.throw "dd277420-6b62-4375-bda8-93dc2326d3bf" ;
                                    in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } ( import ./scripts.nix ) ;
                              shellHook =
                                let
                                  lambda = track : { shellHook = track.reduced ( scripts ( { script } : script ) ) ; } ;
                                  null = track : { } ;
                                  undefined = track : track.throw "d301ebaa-b1b0-4cad-b56a-361852956a42" ;
                                  in visit { lambda = lambda ; null = null ; undefined = undefined ; } hook ;
                              tokenizers =
                                {
                                  identifier = seed : builtins.toString ( seed + 3 ) ;
                                  uuid = seed : builtins.hashString "sha512" ( builtins.toString seed ) ;
                                  variable = seed : builtins.concatStringsSep "_" [ "VARIABLE" ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] ;
                                } ;
                              in pkgs.mkShell ( buildInputs // shellHook ) ;
                        }
                  ) ;
         } ;
  }
