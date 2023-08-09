{
  build ,
  err ,
  host ,
  null ,
  out ,
  private ,
  scripts ,
  structure-directory ,
  target 
} @ arguments :
  let
    inject = builtins.import ./inject.nix ;
    script = builtins.import ./script.nix ;
    value =
      fun :
        let
          lambda = track : inject script ( arguments // { fun = fun ; lambda = track.input ; track = track ; } ) ;
          list = track : track.interim ;
          null = track : null ;
          set = track : track.interim ;
          string = track : inject script ( arguments // { fun = lambda ; lambda = { } : track.input ; track = track ; } ) ;
          undefined = track : track.throw "c5b5d2c5-1a8e-4ef4-945e-94129de606f6" ;
          in visit { lambda = lambda ; list = list ; null = null ; set = set ; string = string ; undefined = undefined ; } arguments.scripts ;
    visit = builtins.import ./visit.nix ;
    in value
