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
                {
                  bash-variable ? _.bash-variable ,
                  hook ? null ,
                  cron ? "/etc/cron.d" ,
                  inputs ? null ,
                  knull ? "/dev/null" ,
                  nixpkgs ? _.nixpkgs ,
                  strip ? _.strip ,
                  structure-directory ,
                  sudo ? "/usr/bin/sudo" ,
                  unique ? _.unique ,
                  visit ? _.visit
                } :
                  flake-utils.lib.eachDefaultSystem
                    (
                      system :
                        {
                          devShell =
                            let
                              buildInputs =
                                let
                                  lambda = track : { buildInputs = track.reduced ( scripts ( { shell-script-bin } : shell-script-bin ) global ) ; } ;
                                  null = track : { } ;
                                  undefined = track : track.throw "11d8d120-d631-4fec-9229-a5162062352b" ;
                                  in visit { lambda = lambda ; null = null ; undefined = undefined ; } inputs ;
                              global =
                                unique
                                  { timestamp = tokenizers.variable null ; uuid = tokenizers.uuid null ; }
                                  ( scripts ( { script } : script ) )
                                  (
                                    token :
                                      let
                                        list = track : builtins.all ( i : i ) track.reduced ;
                                        set = track : builtins.all ( i : i ) ( builtins.attrValues track.reduced ) ;
                                        string = track : builtins.replaceStrings [ token ] [ "" ] track.reduced == track.reduced ;
                                        undefined = track : track.throw "2c056c9a-24f4-4a7d-a8f0-c470423ee332" ;
                                        in visit { list = list ; set = set ; string = string ; undefined = undefined ; }
                                  ) ;
                              invoke = fun : args : fun ( builtins.intersectAttrs ( builtins.functionArgs fun ) args ) ;
                              pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                              scripts =
                                fun : global :
                                  let
                                    appraisal =
                                      track : reduced :
                                        let
                                          local =
                                            unique
                                              {
                                                numbers =
                                                  {
                                                    structure-directory = tokenizers.identifier ;
                                                    temporary-directory = tokenizers.identifier ;
                                                    temporary-dir = tokenizers.identifier ;
                                                    log-directory = tokenizers.identifier ;
                                                    log-dir = tokenizers.identifier ;
                                                    resource-directory = tokenizers.identifier ;
                                                    resource-dir = tokenizers.identifier ; test = tokenizers.identifier ;
                                                  } ;
                                                variables =
                                                  {
                                                    temporary-dir = tokenizers.variable track.index ;
                                                    log-dir = tokenizers.variable track.index ;
                                                    salt = tokenizers.variable track.index ;
                                                    timestamp = tokenizers.variable track.index ;
                                                    parent =
                                                      {
                                                        timestamp = tokenizers.variable track.index ;
                                                        process = tokenizers.variable track.index ;
                                                        salt = tokenizers.variable track.index ;
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
                                              log = if builtins.any ( functionArg : functionArg == "log" ) ( builtins.attrNames ( builtins.functionArgs track.reduced ) ) then scripting.log.yes else scripting.log.no ;
                                              scripting =
                                                let
                                                  set = track : track.reduced ;
                                                  string = track : strip track.reduced ;
                                                  undefined = track : track.throw "" ;
                                                  in visit { set = set ; string = string ; undefined = undefined ; } ( import ./scripting.nix { bash-variable = bash-variable ; coreutils = pkgs.coreutils ; flock = pkgs.flock ; global = global ; local = local ; structure-directory = structure-directory ; } ) ;
                                              structure = if builtins.any ( functionArg : builtins.any ( dir : functionArg == dir ) [ "log" "resources" "temporary" ] ) ( builtins.attrNames ( builtins.functionArgs track.reduced ) ) then scripting.structure.yes else scripting.structure.no ;
                                              resource = if builtins.any ( functionArg : functionArg == "resources" ) ( builtins.attrNames ( builtins.functionArgs track.reduced ) ) then scripting.resource.yes else scripting.resource.no ;
                                              temporary = if builtins.any ( functionArg : functionArg == "temporary" ) ( builtins.attrNames ( builtins.functionArgs track.reduced ) ) then scripting.temporary.yes else scripting.temporary.no ;
                                              in
                                                strip
                                                  ''
                                                    # ${ local.uuid }
                                                    # ${ track.qualified-name }
 
                                                    ${ structure } &&

                                                    ${ temporary } &&

                                                    ${ log } &&

                                                    ${ resource } &&

                                                    ${ script }
                                                  '' ;
                                          shell-script-bin = pkgs.writeShellScriptBin track.simple-name program ;
                                          shell-script = pkgs.writeShellScript track.simple-name program ;
                                          _resources =
                                            fun : list : set :
                                              let
                                                lambda =
                                                  track :
                                                    let
                                                      resource =
                                                        { directory ? null , file ? null , release ? null , output ? null , permissions ? null , salt ? null , show ? null } :
                                                          let
                                                            hash = "$( ${ pkgs.coreutils }/bin/echo ${ pre-salt } ${ salted.salt } | ${ pkgs.coreutils }/bin/md5sum | ${ pkgs.coreutils }/bin/cut --bytes -32 )" ;
                                                            init =
                                                              if builtins.typeOf salted.output == "string" && builtins.typeOf salted.file == "bool" then "${ salted.output } ${ bash-variable global.timestamp } > ${ structure-directory }/resource/${ bash-variable "HASH" }/resource"
                                                              else if builtins.typeOf salted.output == "bool" && builtins.typeOf salted.file == "string" then "${ salted.file } ${bash-variable global.timestamp } ${ structure-directory }/resource/${ bash-variable "HASH" }/resource"
                                                              else builtins.throw "d35f79cc-01e0-4305-a6cd-07e1fcbe02c9" ;
                                                            invocation = "$( ${ pkgs.writeShellScript "init" ( ( builtins.import ./resource.nix ) bash-variable local.numbers.resource-dir pkgs.coreutils pkgs.flock structure-directory pre-salt salted.salt init unsalted.show ) } )" ;
                                                            pre-salt = builtins.hashString "sha512" ( builtins.concatStringsSep "" ( builtins.map builtins.toString ( builtins.attrValues salted ) ) ) ;
                                                            salted =
                                                              {
                                                                file =
                                                                  let
                                                                    lambda = track : track.reduced ( scripts ( { shell-script } : shell-script ) global ) ;
                                                                    null = track : false ;
                                                                    undefined = track : track.throw "67effc1b-0e46-4f9b-91ee-5d648dedad4c" ;
                                                                    in visit { lambda = lambda ; null = null ; undefined = undefined ; } file ;
                                                                output =
                                                                  let
                                                                    lambda = track : track.reduced ( scripts ( { shell-script } : shell-script ) global ) ;
                                                                    null = track : false ;
                                                                    undefined = track : track.throw "1ea15780-74da-454b-9012-a733620d5248" ;
                                                                    in visit { lambda = lambda ; null = null ; undefined = undefined ; } output ;
                                                                salt =
                                                                  let
                                                                    float = track : "$(( ${ bash-variable global.timestamp } / ${ builtins.toString track.reduced } ))" ;
                                                                    int = track : "$(( ${ bash-variable global.timestamp } / ${ builtins.toString track.reduced } ))" ;
                                                                    lambda = track : "$( ${ track.reduced ( scripts ( { shell-script } : shell-script ) global ) } ${ bash-variable global.timestamp } )" ;
                                                                    null = track : "$(( ${ bash-variable global.timestamp } / ${ builtins.toString ( 60 * 60 ) } ))" ;
                                                                    undefined = track : track.throw "9c8cfa72-abd4-4e93-8579-a9c3e7255d95" ;
                                                                    in visit { float = float ; int = int ; lambda = lambda ; null = null ; undefined = undefined ; } salt ;
                                                              } ;
                                                            unsalted =
                                                              {
                                                                show =
                                                                  let
                                                                    bool = track : if track.reduced then "cat" else "echo" ;
                                                                    null = track : "cat" ;
                                                                    in visit { bool = bool ; null = null ; undefined = undefined ; } show ;
                                                              } ;
                                                            in invoke fun { hash = hash ; invocation = invocation ; } ;
                                                      in track.reduced resource ;
                                                undefined = track : track.throw "90ae8007-6137-4823-8923-89726347d15b" ;
                                                in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } ( import ./resources.nix ) ;
                                          script = strip ( script-fun local ) ;
                                          script-fun = local : invoke reduced ( structure local ) ;
                                          structure =
                                            local :
                                              pkgs //
                                                {
                                                  bash-variable = bash-variable ;
                                                  dev = { cron = cron ; null = knull ; sudo = sudo ; } ;
                                                  foobar = true ;
                                                  hashes =
                                                    let
                                                      fun = { hash } : [ hash ] ;
                                                      list = track : builtins.concatLists ( track.reduced ) ;
                                                      set = track : builtins.concatLists ( builtins.attrValues track.reduced ) ;
                                                      in builtins.concatStringsSep " " ( _resources fun list set ) ;
                                                  local = local ;
                                                  log = name : ">( ${ pkgs.moreutils }/bin/ts %.s > $( ${ pkgs.coreutils }/bin/mktemp --suffix .${ builtins.hashString "sha512" ( builtins.toString name ) } ${ bash-variable local.variables.log-dir }/XXXXXXXX ) 2> ${ knull } )" ;
                                                  resources = _resources ( { invocation } : invocation) ( track : track.reduced ) ( track : track.reduced ) ;
                                                  shell-scripts = scripts ( { shell-script } : shell-script ) global ;
                                                  structure-directory = structure-directory ;
                                                  temporary = "${ bash-variable local.variables.temporary-dir }/temporary" ;
                                                  track = track ;
                                                  uuid = local.uuid ;
                                                } ;
                                          in invoke fun { script = script ; script-fun = script-fun ; shell-script = shell-script ; shell-script-bin = shell-script-bin ; } ;
                                    value =
                                      let
                                        lambda = track : appraisal track track.reduced ;
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        string = track : appraisal track ( { } : track.reduced ) ;
                                        undefined = track : track.throw "dd277420-6b62-4375-bda8-93dc2326d3bf" ;
                                        in visit { lambda = lambda ; list = list ; set = set ; string = string ; undefined = undefined ; } ( import ./scripts.nix ) ;
                                    in value ;
                              shellHook =
                                let
                                  lambda = track : { shellHook = track.reduced ( scripts ( { script } : script ) global ) ; } ;
                                  null = track : { } ;
                                  undefined = track : track.throw "d301ebaa-b1b0-4cad-b56a-361852956a42" ;
                                  in visit { lambda = lambda ; null = null ; undefined = undefined ; } hook ;
                              tokenizers =
                                {
                                  identifier =
                                    track : seed :
                                      let
                                        abs = value : if value > 0 then value else - value ;
                                        hash =
                                          dividend :
                                            let
                                              list = builtins.genList ( i : builtins.substring i 1 string ) ( builtins.stringLength string ) ;
                                              mapper =
                                                i :
                                                  if i == "0" then 0
                                                  else if i == "1" then 1
                                                  else if i == "2" then 2
                                                  else if i == "3" then 3
                                                  else if i == "4" then 4
                                                  else if i == "5" then 5
                                                  else if i == "6" then 6
                                                  else if i == "7" then 7
                                                  else if i == "8" then 8
                                                  else if i == "9" then 9
                                                  else if i == "a" then 10
                                                  else if i == "b" then 11
                                                  else if i == "c" then 12
                                                  else if i == "d" then 13
                                                  else if i == "e" then 14
                                                  else if i == "f" then 15
                                                  else builtins.throw "c36268d8-3c14-4d8b-9d0c-610ff94ca496" ;
                                              string = builtins.hashString "sha512" ( builtins.toString dividend ) ;
                                              in builtins.foldl' ( previous : current : abs ( previous * 16 + current ) ) 0 ( builtins.map mapper list ) ;
                                        modulus =
                                          dividend : divisor :
                                            let
                                              quotient = dividend / divisor ;
                                              in dividend - quotient * divisor ;
                                        in builtins.toString ( 3 + modulus ( hash ( seed + track.index ) ) ( 256 - 3 ) ) ;
                                  uuid = id : track : seed : builtins.hashString "sha512" ( builtins.concatStringsSep "" ( builtins.map builtins.toString [ seed id track.index ] ) ) ;
                                  variable = id : track : seed : builtins.concatStringsSep "_" [ "VARIABLE" ( builtins.hashString "md5" ( builtins.concatStringsSep "" ( builtins.map builtins.toString [ seed id track.index ] ) ) ) ] ;
                                } ;
                              in pkgs.mkShell ( buildInputs // shellHook ) ;
                        }
                  ) ;
         } ;
  }
