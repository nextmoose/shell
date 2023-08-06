let
  bool = track : if track.input then "true" else "false" ;
  lambda = track : track.throw "06d3eed8-0c3a-4995-9562-faf6ef479d43" ;
  list = track : builtins.concatStringsSep "" track.input ;
  set = track : builtins.concatStringsSep "" ( builtins.attrValues track.input ) ;
  undefined = track : builtins.toString track.input ;
  in builtins.import ./visit.nix { bool = bool ; lambda = lambda ; list = list ; set = set ; undefined = undefined ; }
