  {
    inputs =
      {
        bash-variable.url = "/home/emory/Desktop/structure/flakes/bash-variable" ;
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843"  ;
        strip.url = "/home/emory/Desktop/structure/flakes/strip" ;
        unique.url = "/home/emory/Desktop/structure/flakes/unique" ;
        visit.url = "/home/emory/Desktop/structure/flakes/visit" ;
      } ;
    outputs =
      { bash-variable , flake-utils , nixpkgs , self , strip , unique , visit } :
        {
          lib =
            let
              _ =
                {
                  bash-variable = bash-variable.lib { } ;
                  nixpkgs = nixpkgs ;
                  strip = strip.lib { } ;
                  unique = unique.lib { } ;
                  visit = visit.lib { } ;
                } ;
              in
                { bash-variable ? _.bash-variable , hook ? null , inputs ? null , knull ? "/dev/null" , nixpkgs ? _.nixpkgs , strip ? _.strip , structure-directory , unique ? _.unique , visit ? _.visit } :
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
                                                numbers = { structure-directory = tokenizers.identifier ; temporary-directory = tokenizers.identifier ; temporary-dir = tokenizers.identifier ; log-directory = tokenizers.identifier ; log-dir = tokenizers.identifier ; resource-directory = tokenizers.identifier ; resource-dir = tokenizers.identifier ; } ;
                                                variables =
                                                  {
                                                    temporary-dir = tokenizers.variable "TEMPORARY" track ;
                                                    log-dir = tokenizers.variable "LOG" track ;
                                                    salt = tokenizers.variable "SALT" track ;
                                                    timestamp = tokenizers.variable "TIMESTAMP" track ;
                                                    parent =
                                                      {
                                                        timestamp = tokenizers.variable "PARENTTIMESTAMP" track ;
                                                        process = tokenizers.variable "PARENTPROCESS" track ;
                                                        salt = tokenizers.variable "PARENTSALT" track ;
                                                      } ;
                                                  } ;
                                                uuid = tokenizers.uuid track.index ;
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
                                              is =
                                                {
                                                  log = builtins.replaceStrings [ local.variables.log-dir ] [ "" ] script != script ;
                                                  temporary = builtins.replaceStrings [ local.variables.temporary-dir ] [ "" ] script != script ;
                                                  resource = builtins.any ( key : key == "resources" ) ( builtins.attrNames ( builtins.functionArgs track.reduced ) ) ;
                                                } ;
                                              log =
                                                if is.log then scripts.structure.script.temporary { bash-variable = bash-variable ; coreutils = pkgs.coreutils ; directory = "log" ; file-descriptor-directory = local.numbers.log-directory ; file-descriptor-dir = local.numbers.log-dir ; flock = pkgs.flock ; label = "LOG" ; structure-directory = structure-directory ; temporary-dir = local.variables.log-dir ; }
                                                else scripts.structure.script.no { label = "NO LOGS" ; } ;
                                              resource =
                                                if is.resource then scripts.structure.script.resource { bash-variable = bash-variable ; coreutils = pkgs.coreutils ; file-descriptor-directory = local.numbers.resource-directory ; flock = pkgs.flock ; structure-directory = structure-directory ; timestamp = local.variables.timestamp ; }
                                                else scripts.structure.script.no { label = "NO RESOURCES" ; } ;
                                              scripts = import ./scripts.nix ;
                                              structure =
                                                if is.temporary || is.log || is.resource then scripts.structure.script.structure { coreutils = pkgs.coreutils ; file-descriptor = local.numbers.structure-directory ; flock = pkgs.flock ; structure-directory = structure-directory ; }
                                                else scripts.structure.script.no { label = "NO STRUCTURES" ; } ;
                                              temporary =
                                                if is.temporary then scripts.structure.script.temporary { bash-variable = bash-variable ; coreutils = pkgs.coreutils ; directory = "temporary" ; file-descriptor-directory = local.numbers.temporary-directory ; file-descriptor-dir = local.numbers.temporary-dir ; flock = pkgs.flock ; label = "TEMPORARY" ; structure-directory = structure-directory ; temporary-dir = local.variables.temporary-dir ; }
                                                else scripts.structure.script.no { label = "TEMPORARY" ; } ;
                                              in scripts.structure.script.main { bash-variable = bash-variable ; log = log ; resource = resource ; script = script ; strip = strip ; structure = structure ; temporary = temporary ; track = track ; uuid = local.uuid ; writeShellScript = pkgs.writeShellScript ; } ;
                                          shell-script-bin = pkgs.writeShellScriptBin track.simple-name program ;
                                          shell-script = pkgs.writeShellScript track.simple-name program ;
                                          resources =
					    local :
                                              let
                                                lambda =
                                                  track :
                                                    let
                                                      resource =
                                                        { directory ? null , file ? null , release ? null , output ? null , permissions ? null , salt ? null , show ? null } :
                                                          let
                                                            init =
                                                              let
                                                                filtered = builtins.filter ( init : builtins.typeOf init == "string" ) [ salted.file salted.output ] ;
                                                                in if builtins.length filtered == 1 then builtins.head filtered else builtins.throw "1ee526eb-da65-4dbd-bfef-17c848eb4943" ;
                                                            pre-salt = builtins.hashString "sha512" ( builtins.concatStringsSep "" ( builtins.map builtins.toString ( builtins.attrValues salted ) ) ) ;
                                                            salted =
                                                              {
                                                                file =
                                                                  let
                                                                    lambda = track : "${ track.reduced ( scripts ( { shell-script } : shell-script ) ) } ${ structure-directory }/resource/${ bash-variable "SALT" }/resource" ;
                                                                    null = track : false ;
                                                                    undefined = track : track.throw "5c1a0b42-4ed7-482a-b951-2fb5e26aa023" ;
                                                                    in visit { lambda = lambda ; null = null ; undefined = undefined ; } file ;
                                                                output =
                                                                  let
                                                                    lambda = track : "${ track.reduced ( scripts ( { shell-script } : shell-script ) ) } > ${ structure-directory }/resource/${ bash-variable "SALT" }/resource" ;
                                                                    null = track : false ;
                                                                    undefined = track : track.throw "d9d41488-1973-41e6-a62e-9431d4317b52" ;
                                                                    in visit { lambda = lambda ; null = null ; undefined = undefined ; } output ;
                                                                permissions =
                                                                  let
                                                                    float = track : builtins.substring 1 4 ( builtins.toString ( track.reduced + 10000 ) ) ;
                                                                    int = track : builtins.substring 1 4 ( builtins.toString ( track.reduced + 10000 ) ) ;
                                                                    null = track : "0400" ;
                                                                    string = track : track.reduced ;
                                                                    undefined = track : track.throw "76ba61d8-d74e-4e33-927d-9c1a224ed5d6" ;
                                                                    in visit { float = float ; int = int ; null = null ; string = string ; undefined = undefined ; } permissions ;
                                                               release =
                                                                 let
                                                                   lambda = track : track.reduced ( scripts ( { shell-script } : shell-script ) ) ;
                                                                   null = track : "" ;
                                                                   undefined = track : track.throw "e322c462-0ce7-4a8a-bdb6-8b40268b2317" ;
                                                                   in visit { lambda = lambda ; null = null ; undefined = undefined ; } release ;
                                                                 salt =
                                                                   let
                                                                     float = track : "$(( ${ bash-variable "TIMESTAMP" } / ${ builtins.toString track.reduced } ))" ;
                                                                     int = track : "$(( ${ bash-variable "TIMESTAMP" } / ${ builtins.toString track.reduced } ))" ;
                                                                     lambda = track : "${ track.reduced ( scripts ( { shell-script } : shell-script ) ) } ${ bash-variable "TIMESTAMP" }" ;
                                                                     null = track : "$(( ${ bash-variable "TIMESTAMP" } / ${ builtins.toString ( 60 * 60 ) } ))" ;
                                                                     undefined = track : track.throw "9c8cfa72-abd4-4e93-8579-a9c3e7255d95" ;
                                                                     in visit { float = float ; int = int ; lambda = lambda ; null = null ; undefined = undefined ; } salt ;
                                                              } ;
                                                            script =
                                                              let
                                                                scripts = import ./scripts.nix ;
                                                                in scripts.structure.resource.main { bash-variable = bash-variable ; coreutils = pkgs.coreutils ; file-descriptor-dir = local.numbers.resource-dir ; flock = pkgs.flock ; init = init ; permissions = salted.permissions ; pre-salt = pre-salt ; salt = salted.salt ; show = unsalted.show ; strip = strip ; structure-directory = structure-directory ; } ;
                                                            unsalted =
                                                              {
                                                                show =
                                                                  let
                                                                    bool =
                                                                      track :
                                                                        let
                                                                          resource = { coreutils = pkgs.coreutils ; resource = "${ structure-directory }/resource/${ bash-variable "SALT" }/resource" ; } ;
                                                                          scripts = import ./scripts.nix ;
                                                                          in if track.reduced then scripts.structure.resource.show.cat resource else scripts.structure.resource.show.echo resource ;
                                                                    null =
                                                                      track :
                                                                        let
                                                                          resource = { coreutils = pkgs.coreutils ; resource = "${ structure-directory }/resource/${ bash-variable "SALT" }/resource" ; } ;
                                                                          scripts = import ./scripts.nix ;
                                                                          in scripts.structure.resource.show.cat resource ;
                                                                    undefined = track : track.throw "757955e3-5be4-40a7-81af-abaa59972c91" ;
                                                                    in visit { bool = bool ; null = null ; undefined = undefined ; } show ;
                                                              } ;
                                                            in "$( ${ pkgs.writeShellScript track.simple-name ( strip script ) } ${ bash-variable local.variables.timestamp } ${ bash-variable "$" } )" ;
                                                      in track.reduced resource ;
                                                list = track : track.reduced ;
                                                set = track : track.reduced ;
                                                undefined = track : track.throw "21628eb5-e712-4e11-a756-f23ff8efaa03" ;
                                                in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } ( import ./resources.nix ) ;
                                          script = strip ( script-fun local ) ;
                                          script-fun = local : invoke track.reduced ( structure local ) ;
                                          structure =
                                            local :
                                              pkgs //
                                                {
                                                  bash-variable = bash-variable ;
                                                  dev = { null = knull ; } ;
                                                  init =
                                                    let
                                                      init = strip ( scripts.structure.script.init { bash-variable = bash-variable ; coreutils = pkgs.coreutils ; process = local.variables.parent.process ; salt = local.variables.parent.salt ; timestamp = local.variables.parent.timestamp ; } ) ;
                                                      scripts = import ./scripts.nix ;
                                                      in init ;
                                                  log = name : ">( ${ pkgs.moreutils }/bin/ts %.s > $( ${ pkgs.coreutils }/bin/mktemp --suffix .${ builtins.hashString "sha512" ( builtins.toString name ) } ${ bash-variable local.variables.log-dir }/XXXXXXXX ) 2> ${ knull } )";
                                                  release =
                                                    let
                                                      scripts = import ./scripts.nix ;
                                                      in
                                                        {
                                                          log = strip ( scripts.structure.release.log { bash-variable = bash-variable ; coreutils = pkgs.coreutils ; file-descriptor-directory = local.numbers.log-directory ; file-descriptor-dir = local.numbers.log-dir ; findutils = pkgs.findutils ; flock = pkgs.flock ; gnused = pkgs.gnused ; resources = resources local ; structure-directory = structure-directory ; } ) ;
                                                          temporary = strip ( scripts.structure.release.temporary { bash-variable = bash-variable ; coreutils = pkgs.coreutils ; file-descriptor-directory = local.numbers.temporary-directory ; file-descriptor-dir = local.numbers.temporary-dir ; findutils = pkgs.findutils ; flock = pkgs.flock ; structure-directory = structure-directory ; } ) ;
                                                        } ;
                                                  resources = resources local ;
                                                  strip = strip ;
                                                  temporary = bash-variable local.variables.temporary-dir ;
                                                  uuid = local.uuid ;
                                                } ;
                                          in invoke fun { script = script ; shell-script = shell-script ; shell-script-bin = shell-script-bin ; } ;
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
                                  uuid = index : seed : builtins.hashString "sha512" ( builtins.concatStringsSep "" ( builtins.map builtins.toString [ seed index ] ) ) ;
                                  variable = name : track : seed : builtins.concatStringsSep "_" [ "VARIABLE" name ( builtins.hashString "md5" ( builtins.concatStringsSep "" ( builtins.map builtins.toString [ seed 0 ] ) ) ) ] ;
                                } ;
                              in pkgs.mkShell ( buildInputs // shellHook ) ;
                        }
                  ) ;
         } ;
  }
