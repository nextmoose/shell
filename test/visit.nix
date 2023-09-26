  {
    bool ? builtins.null ,
    float ? builtins.null ,
    int ? builtins.null ,
    lambda ? builtins.null ,
    list ? builtins.null ,
    null ? builtins.null ,
    path ? builtins.null ,
    set ? builtins.null ,
    string ? builtins.null ,
    undefined ? builtins.null
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
                let
                  simple-name =
                    let
                      last = if length > 0 then builtins.elemAt ( length - 1 ) path else builtins.throw "9984f04f-b293-43a3-92ec-83c7777f5461" ;
                      length = builtins.length path ;
                      in if builtins.typeOf last == "string" then last else builtins.throw "fe3ca6f9-541c-4e42-9918-fd79583fe0d9" ;
                  qualified-name =
                    let
                      mapper =
                        element :
                          if builtins.typeOf element == "int" then builtins.concatStringsSep " " [ "[" ( builtins.toString element ) "]" ]
                          else if builtins.typeOf element == "string" then builtins.concatStringsSep " " [ "{" element "}" ]
                          else builtins.throw "0b958f09-5de3-41e8-a5ff-30076f0492fe" ;
                    reducer = previous : current : builtins.concatStringsSep "" [ previous current ] ;
                    in builtins.foldl' reducer "" ( builtins.map mapper path ) ;
                  string =
                    if type == "lambda" then builtins.concatStringsSep "" [ "<" type ">" ]
                    else if type == "list" then builtins.concatStringsSep "" [ "<" type ">" ]
                    else if type == "set" then builtins.concatStringsSep "" [ "<" type ">" ]
                    else if type == "string" then builtins.concatStringsSep "" [ "<" type " " "\"" input "\"" ">" ]
                    else if type == "bool" then builtins.concatStringsSep "" [ "<" "bool" " " ( if input then "true" else "false" ) ">" ]
                    else builtins.concatStringsSep "" [ "<" type " " ( builtins.toString input ) ">" ] ;
                  in
                    {
                      index = index ;
                      input = input ;
                      interim = interim ;
                      path = path ;
                      qualified-name = qualified-name ;
                      simple-name = simple-name ;
                      throw = uuid : builtins.throw ( builtins.concatStringsSep "\n" [ "visit error" "18c1b7ad-6503-4361-b9e3-8b671689ed19" uuid qualified-name type string ] ) ;
                    } ;
            type = builtins.typeOf input ;
            in output ;
      lambdas =
        let
          input = { bool = bool ; float = float ; int = int ; lambda = lambda ; list = list ; null = null ; path = path ; set = set ; string = string ; } ;
          mapper = name : value : if builtins.typeOf value == "lambda" then value else if builtins.typeOf undefined == "lambda" then undefined else builtins.throw "266e49d4-7ae0-448b-a9e4-187573434d78" ;
          in builtins.mapAttrs mapper input ;
      in fun 0 [ ]