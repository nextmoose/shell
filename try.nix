fun :
  let
    test =
      seed :
        let
          result = fun seed ;
          in if result.success then result.value else test ( seed + 1 ) ;
    in test 0