let
  denulled =
    lambda :
      let
        list = track : track.interim ;
	null = track : builtins.foldl' ( previous : current : previous current ) ( lambda track.index ) track.path ;
	set = track : track.interim ;
	undefined = track : track.throw "46098193-2176-441d-a426-22ef6b995136" ;
	in visit { list = list ; null = null ; set = set ; undefined = undefined ; } ;
  nulled = builtins.foldl' reducer null ;
  reducer =
    previous : current :
      let
        c =
	  let
	    int = track : builtins.genList ( index : null ) track.input ;
	    list = track : builtins.listToAttrs ( builtins.map ( name : { name = name ; value = null ; } ) track.input ) ;
	    undefined = track : track.throw "a0b34fff-c88d-4068-abd7-08b2a33a6f4b" ;
	    in visit { int = int ; list = list ; undefined = undefined ; } current ;
	p =
	  let
	    list = track : track.interim ;
	    null = track : c ;
	    set = track : track.interim ;
	    undefined = track : track.throw "59fc87ec-ef19-4b71-939d-c4b652cb2cb7" ;
	    in visit { list = list ; null = null ; set = set ; undefined = undefined ; } previous ;
        in p ;
  visit = builtins.import ./visit.nix ;
  in lambda : arguments : denulled lambda ( nulled arguments )
