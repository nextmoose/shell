{
  build ,
  err ,
  hash ,
  host ,
  null ,
  out ,
  path ,
  private ,
  process ,
  scripts ,
  shared ,
  structure-directory ,
  target ,
  timestamp ,
  variables
} @ arguments :
  let
    inject = builtins.import ./inject.nix ;
    script = builtins.import ./script.nix ;
    try = builtins.import ./try.nix ;
    value =
      fun :
        let
          lambda =
            track :
              let
                variables =
                  let
                    input = builtins.genList ( x : null ) 4 ;
                    output = builtins.foldl' reducer [ ] input ;
                    reducer =
                      previous : current :
                        let
                          fun =
                            seed :
                              let
                                value = builtins.hashString "sha512" ( builtins.toString seed ) ;
                                in
                                  {
                                    success =
                                      let
                                        lambda =
                                          track :
                                            let
                                              scripts =
                                                let
                                                  lambda =
                                                    track :
                                                      let
                                                        lambda = x : string ;
                                                        penultimate =
                                                          {
                                                            bash-variable = lambda ;
                                                            isolated = lambda ;
                                                            shell-script = lambda ;
                                                            shell-script-bin = lambda ;
                                                            hash = string ;
                                                            path = string ;
                                                            process = string ;
                                                            timestamp = string ;
                                                          } ;
                                                        string = "" ;
                                                        in inject track.input ( arguments // penultimate ) ;
                                                  list = track : track.interim ;
                                                  null = track : builtins.null ;
                                                  set = track : track.interim ;
                                                  string = track : track.input ;
                                                  undefined = track : track.throw "000c437d-a0f9-4a58-951d-7d5b2a6101f9" ;
                                                  in visit { lambda = lambda ; list = list ; null = null ; set = set ; string = string ; undefined = undefined ; } arguments.scripts ;
                                              string = builtins.toJSON scripts ;
                                              in builtins.replaceStrings [ value ] [ "" ] string == string && builtins.all ( p : p != value ) previous ;
                                        list = track : builtins.all ( x : x ) track.interim ;
                                        null = track : true ;
                                        set = track : builtins.all ( x : x ) ( builtins.attrValues track.interim ) ;
                                        string = track : builtins.replaceStrings [ value ] [ "" ] track.input == track.input && builtins.all ( p : p != value ) previous ;
                                        undefined = track : track.throw "9d417eb9-f3dc-4089-9892-da49f8ba190a" ;
                                        in visit { lambda = lambda ; list = list ; null = null ; set = set ; string = string ; undefined = undefined ; } arguments.scripts ;
                                    value = builtins.concatLists [ previous [ value ] ] ;
                                  } ;
                          in try fun ;
                    in 
                      {
                        hash = builtins.concatStringsSep "_" [ "HASH" ( builtins.elemAt output 0 ) ] ;
                        path = builtins.concatStringsSep "_" [ "PATH" ( builtins.elemAt output 1 ) ] ;
                        process = builtins.concatStringsSep "_" [ "PROCESS" ( builtins.elemAt output 2 ) ] ;
                        timestamp = builtins.concatStringsSep "_" [ "TIMESTAMP" ( builtins.elemAt output 3 ) ] ;
                      } ;
                in inject script ( arguments // variables ) fun track ;
          list = track : track.interim ;
          null = track : builtins.null ;
          set = track : track.interim ;
          string = track : inject script arguments fun track ;
          undefined = track : track.throw "c5b5d2c5-1a8e-4ef4-945e-94129de606f6" ;
          in visit { lambda = lambda ; list = list ; null = null ; set = set ; string = string ; undefined = undefined ; } arguments.scripts ;
    visit = builtins.import ./visit.nix ;
    in value
