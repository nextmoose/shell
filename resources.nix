  {
    cron = resource : resource { file = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
    identity = resource : resource { file = scripts : scripts.ssh.identity ; show = false ; } ;
    log =
      {
        file = resource : resource { file = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
        lock = resource : resource { file = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
      } ;
    name = resource : resource { output = scripts : scripts.name ; show = true ; } ;
    test =
      {
        alpha = resource : resource { file = scripts : scripts.touch ; salt = 60 * 01 ; show = false ; permissions = 0600 ; } ;
        beta = resource : resource { file = scripts : scripts.touch ; salt = 60 * 01 ; show = false ; permissions = 0600 ; } ;
        gamma = resource : resource { file = scripts : scripts.touch ; salt = 60 * 01 ; show = false ; permissions = 0600 ; } ;
        lock = resource : resource { file = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
      } ;
  }