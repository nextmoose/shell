try :
  let
    trial =
      seed :
        let
          eval = try seed ;
          in if eval.success then eval.value else trial ( seed + 1 ) ;
    in trial 0