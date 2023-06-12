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
        alpha = resource : resource { file = scripts : scripts.test.log.resources.alpha.init ; release = scripts : scripts.test.log.resources.alpha.release ; salt = 1 ; } ;
        beta = resource : resource { file = scripts : scripts.test.log.resources.beta.init ; release = scripts : scripts.test.log.resources.beta.release ; salt = 60 * 60 * 24 * 7 ; } ;
        gamma = resource : resource { file = scripts : scripts.test.log.resources.gamma.init ; release = scripts : scripts.test.log.resources.gamma.release ; salt = 60 * 60 * 24 * 7 ; } ;
        lock = resource : resource { file = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
      } ;
  }