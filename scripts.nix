{
  build ,
  err ,
  hash ,
  host ,
  null ,
  out ,
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
          lambda = track : inject script arguments fun track ;
          list = track : track.interim ;
          null = track : builtins.null ;
          set = track : track.interim ;
          string = track : inject script arguments fun track ;
          undefined = track : track.throw "c5b5d2c5-1a8e-4ef4-945e-94129de606f6" ;
          in visit { lambda = lambda ; list = list ; null = null ; set = set ; string = string ; undefined = undefined ; } arguments.scripts ;
    visit = builtins.import ./visit.nix ;
    in value
