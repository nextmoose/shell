expression :
  let
    to-string =
      expression :
        if builtins.typeOf expression == "string" then expression
        else if builtins.typeOf expression == "int" then builtins.toString expression
        else if builtins.typeOf expression == "list" then builtins.concatStringsSep "" ( builtins.map to-string expression )
        else if builtins.typeOf expression == "bool" then builtins.throw "fa359c36-1dc6-4609-84ee-4345b9c8940b"
        else if builtins.typeOf expression == "float" then builtins.throw "1784e1b6-0192-48d5-b2a3-b849ffecf48f"
        else if builtins.typeOf expression == "lambda" then builtins.throw "dbdf0fa2-3824-42fd-813f-693552afd50a"
        else if builtins.typeOf expression == "null" then builtins.throw "0876d624-cf93-4a19-b299-ef83075c298f"
        else if builtins.typeOf expression == "path" then builtins.throw "fa359c36-1dc6-4609-84ee-4345b9c8940b"
        else if builtins.typeOf expression == "set" then builtins.throw "cd9b7351-f946-4e85-9f86-fc14b11e047a"
        else builtins.throw "76c886d1-93d0-4e9f-8c98-dbeb6147eea2" ;
      in builtins.concatStringsSep "" [ "$" "{" ( to-string expression ) "}" ]