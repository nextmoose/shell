let
  reducer =
    previous : current :
      let
        c =
	  let
	    int = track : builtins.genList ( index : null ) track.input ;
	    lambda = track : track.input ;
	    list = track : builtins.listToAttrs ( builtins.map ( name : { name = name ; value = null ; } ) track.input ) ;
	    undefined = track : track.throw "a0b34fff-c88d-4068-abd7-08b2a33a6f4b" ;
	    in visit { int = int ; lambda = lambda ; list = list ; undefined = undefined ; } current ;
	p =
	  let
	    lambda = track : track.input ;
	    list = track : track.interim ;
	    null = track : c ;
	    set = track : track.interim ;
	    undefined = track : track.throw "59fc87ec-ef19-4b71-939d-c4b652cb2cb7" ;
	    in visit { lambda = lambda ; list = list ; null = null ; set = set ; undefined = undefined ; } previous ;
        in p ;
  visit = builtins.import ./visit.nix ;
  in
    arguments :
      let
        lambda = track : builtins.foldl' ( previous : current : previous current ) track.input track.path ;
        list = track : track.interim ;
	set = track : track.interim ;
	undefined = track : track.throw "e517d029-fc57-40aa-96a2-492d339f84a5" ;
	in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } ( builtins.foldl' reducer null arguments )
