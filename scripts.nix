{
  build ,
  err ,
  hash ,
  host ,
  null ,
  out ,
  private ,
  scripts ,
  shared ,
  structure-directory ,
  target ,
  timestamp ? "shell/scripts.nix"
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
                    input = builtins.genList ( x : null ) 2 ;
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
						  lambda = track : "" ;
						  list = track : track.interim ;
						  null = track : builtins.null ;
						  set = track : track.interim ;
						  undefined = track : track.throw "000c437d-a0f9-4a58-951d-7d5b2a6101f9" ;
						  in visit { lambda = lambda ; list = list ; null = null ; set = set ; undefined = undefined ; } arguments.scripts ;
					      string = inject script ( arguments // { scripts = scripts ; } ) ( { code } : code ) track ;
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
                        hash = builtins.concatStringsSep "_" [ "HASH" ( builtins.elemAt output 1 ) ] ;
                        timestamp = builtins.concatStringsSep "_" [ "TIMESTAMP" ( builtins.elemAt output 0 ) ] ;
                      } ;
                in inject script ( arguments // { hash = variables.hash ; timestamp = variables.timestamp ; } ) fun track ;
          list = track : track.interim ;
          null = track : builtins.null ;
          set = track : track.interim ;
          string = track : inject script arguments fun track ;
          undefined = track : track.throw "c5b5d2c5-1a8e-4ef4-945e-94129de606f6" ;
          in visit { lambda = lambda ; list = list ; null = null ; set = set ; string = string ; undefined = undefined ; } arguments.scripts ;
    visit = builtins.import ./visit.nix ;
    in value
