  {
    inputs = { flake-utils.url = "github:numtide/flake-utils" ; shell.url = "/home/runner/work/shell/shell" ; } ;
    outputs =
      { flake-utils , shell , self } :
        shell.lib
          {
            hook = scripts : scripts.test.entry ;
            inputs = scripts : [ scripts.test.test-resource ] ;
            structure-directory = "/home/runner/work/_temp" ;
          } ;
  }
