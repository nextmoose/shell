let
  strip =
    expression :
      let
        is-appended = builtins.any ( w : builtins.substring ( length - 1 ) 1 string == w ) whitespace ;
        is-prepended = builtins.any ( w : builtins.substring 0 1 string == w ) whitespace ;
	length = builtins.stringLength string ;
	step =
	  if is-appended then strip ( builtins.substring 0 ( length  - 1 ) string )
	  else if is-prepended then strip ( builtins.substring 1 ( length - 1 ) string )
	  else string ;
        string = stringify expression ;
        stringify = builtins.import ./stringify.nix ;
        whitespace = [ " " "\n" "\t" ] ;
        in step ;
  in strip