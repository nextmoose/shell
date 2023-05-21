  {
    identity = resource : resource { file = scripts : scripts.ssh.identity ; show = false ; } ;
    log =
      {
        file = resource : resource { file = scripts : scripts.touch ; show = false ; permissions = 0600 ; } ;
        lock = resource : resource { file = scripts : scripts.touch ; show = false ; permissions = 0600 ; } ;
      } ;
    name = resource : resource { output = scripts : scripts.name ; show = true ; } ;
  }