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
        alpha = resource : resource { file = scripts : scripts.test.log.resources.alpha.init ; salt = 2 ; } ;
        beta = resource : resource { file = scripts : scripts.test.log.resources.beta.init ; salt = 3 ; } ;
        gamma = resource : resource { file = scripts : scripts.test.log.resources.gamma.init ; salt = 3 ; } ;
        lock = resource : resource { file = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
      } ;
  }