  {
    identity = resource : resource { file = scripts : scripts.ssh.identity ; show = false ; } ;
    name = resource : resource { output = scripts : scripts.name ; show = true ; } ;
  }