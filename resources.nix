  {
    cron = resource : resource { file = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
    identity = resource : resource { file = scripts : scripts.ssh.identity ; show = false ; } ;
    log =
      {
        file = resource : resource { file = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
        lock = resource : resource { file = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
      } ;
    name = resource : resource { output = scripts : scripts.name ; show = true ; } ;
  }