  {
    bool ? false ,
    float ? false ,
    int ? false ,
    lambda ? false ,
    list ? false ,
    null ? false ,
    path ? false ,
    set ? false ,
    string ? false ,
    undefined ? false
  } :
    let
      fun =
        index : path : input :
	  let
	    lambda = builtins.getAttr type lambdas ;
	    output =
	      if type == "list" then
	        let
		  interim = builtins.genList mapper length ;
		  length = builtins.length input ;
		  mapper = i : fun ( index + i ) ( builtins.concatLists [ path [ i ] ] ) ( builtins.elemAt input i ) ;
		  in lambda ( track index path interim )
	      else if type == "set" then
	        let
		  interim = builtins.listToAttrs list ;
		  length = builtins.length names ;
		  list = builtins.genList mapper length ;
		  mapper =
		    i :
		      let
		        name = builtins.elemAt names i ;
			in { name = name ; value = fun ( index + i ) ( builtins.concatLists [ path [ name ] ] ) ( builtins.getAttr name input ) ; } ;
		  names = builtins.attrNames input ;
		  in lambda ( track index path interim )
	      else lambda ( track index path null ) ;
	    track =
	      index : path : interim :
	        {
	          index = index ;
	          input = input ;
		  interim = interim ;
		  path = path ;
		  throw = uuid : builtins.throw "18c1b7ad-6503-4361-b9e3-8b671689ed19" ;
	        } ;
	    type = builtins.typeOf input ;
	    in output ;
      lambdas =
        let
	  input = { bool = bool ; float = float ; int = int ; lambda = lambda ; list = list ; null = null ; path = path ; set = set ; string = string ; } ;
	  mapper = name : value : if builtins.typeOf value == "lambda" then value else if builtins.typeOf undefined == "lambda" then undefined else builtins.throw "266e49d4-7ae0-448b-a9e4-187573434d78" ;
	  in builtins.mapAttrs mapper input ;
      in fun 0 [ ]