let
  value =
    lambda : arguments :
      let
        list = track : track.interim ;
        null = track : builtins.foldl' ( previous : current : previous current ) lambda track.path ;
        set = track : track.interim ;
	undefined = track : track.throw "a70e413c-57ca-4460-ace7-d411aed216f6" ;
	in visit { list = list ; null = null ; set = set ; undefined = undefined ; } arguments ;
  visit = builtins.import ./visit.nix ;
  in value