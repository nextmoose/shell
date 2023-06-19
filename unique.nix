let
  try = import ./try.nix ;
  visit = import ./visit.nix ;
  in
    arguments :
    factory :
    predicate :
      let
        empty =
          let
            lambda = track : "" ;
            list = track : track.reduced ;
            set = track : track.reduced ;
            undefined = track : track.throw "0f5688f2-db73-4b37-b522-3a587ce58030" ;
            in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } arguments ;
        indexed =
          let
            lambda = track : [ ( track.reduced track ) ] ;
            list = track : builtins.concatLists track.reduced ;
            set = track : builtins.concatLists ( builtins.attrValues track.reduced ) ;
            undefined = track : track.throw "196f23f5-6359-47a3-9c5b-a08bf20d3828" ;
	    in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } arguments ;
        reducer =
          previous : current :
            try
              (
                seed :
                  let
                    token = current seed ;
                    in
                      {
                        success = builtins.all ( p : p != token ) previous && predicate token ( factory empty ) ;
                        value = builtins.concatLists [ previous [ token ] ] ;
                      }
              ) ;
        seeded = builtins.foldl' reducer [ ] indexed ;
	transformed =
	  let
	    lambda = track : builtins.elemAt seeded track.index ;
	    list = track : track.reduced ;
	    set = track : track.reduced ;
	    undefined = track : track.throw "5b037dfd-5702-44be-9602-79d14070e3bd" ;
	    in visit { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } arguments ;
	  in transformed
