  {
    inputs = { } ;
    outputs =
      { self } :
        {
          lib =
            {
              build ,
              err ? "/dev/err" ,
	      fun ,
              host ,
              null ? "/dev/null" ,
              out ? "/dev/out" ,
	      private ? null ,
              scripts ,
              structure-directory ,
              target 
            } @ arguments :
	      let
		inject = builtins.import ./inject.nix ;
		scripts = builtins.import ./scripts.nix ;
		in fun ( inject scripts arguments ) ;
        } ;
  }