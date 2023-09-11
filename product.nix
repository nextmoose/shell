let
  reducer =
    previous : current :
      let
        null =
	  track :
	    let
	      path = track.path ;
	      value =
	        let
	          int = track : builtins.genList ( index : null ) track.input ;
	          lambda = track : builtins.foldl' ( previous : current : previous current ) track.input path ;
	          list = track : builtins.listToAttrs ( builtins.map ( name : { name = name ; value = null ; } ) track.input ) ;
	          undefined = track : track.throw "aec0c2a2-b650-44f8-811c-efffad25b53a" ;
	          in visit { int = int ; lambda = lambda ; list = list ; undefined = undefined ; } current ;
	      in value ;
        set = track : track.interim ;
        undefined = track : track.throw "" ;
        in visit { set = set ; undefined = undefined ; } previous ;
  value = arrays : builtins.foldl' reducer null arrays ;
  visit = builtins.import ./visit.nix ;
  in value