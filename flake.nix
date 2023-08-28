  {
    inputs = { } ;
    outputs =
      { self } :
        {
          lib =
            {
              build ,
              err ? "/dev/err" ,
	      hash ? builtins.null ,
              host ,
              null ? "/dev/null" ,
              out ? "/dev/out" ,
	      path ? builtins.null ,
              private ? builtins.null ,
	      process ? builtins.null ,
              scripts ,
              shared ,
              structure-directory ,
              target ,
              timestamp ? builtins.null ,
            } @ _arguments : fun :
              let
	        arguments =
		  {
		    build = _arguments.build ;
		    err = if builtins.hasAttr "err" _arguments then _arguments.err else "/dev/err" ;
		    hash = if builtins.hasAttr "hash" _arguments then _arguments.hash else builtins.null ;
		    host = _arguments.host ;
		    null = if builtins.hasAttr "null" _arguments then _arguments.null else "/dev/null" ;
		    out = _arguments.out ;
		    path = if builtins.hasAttr "path" _arguments then _arguments.path else builtins.null ;
		    private = _arguments.private ;
		    process = if builtins.hasAttr "process" _arguments then _arguments.process else builtins.null ;
		    scripts = _arguments.scripts ;
		    shared = _arguments.shared ;
		    structure-directory = _arguments.structure-directory ;
		    target = _arguments.target ;
		    timestamp = if builtins.hasAttr "timestamp" _arguments then _arguments.timestamp else builtins.null ;
		  } ;
                scripts = builtins.import ./scripts.nix ;
                in fun ( scripts arguments ) ;
        } ;
  } 