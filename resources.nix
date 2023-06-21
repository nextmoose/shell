  {
    cron =
      {
        alpha = resource : resource { salt = scripts : scripts.cron.alpha ; show = false ; } ;
	beta = resource : resource { salt = scripts : scripts.cron.beta ; show = false ; } ;
        log =
	  {
	    jq = resource : resource { init = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
	    log = resource : resource { init = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
	  } ;
        resource = resource : resource { init = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
        temporary = resource : resource { init = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
      } ;
    identity = resource : resource { init = scripts : scripts.ssh.identity ; show = false ; } ;
    log =
      {
        file = resource : resource { init = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
        lock = resource : resource { init = scripts : scripts.touch ; salt = 60 * 60 * 24 * 7 ; show = false ; permissions = 0600 ; } ;
      } ;
    error = resource : resource { init = scripts : scripts.touch ; show = false ; permissions = 0600 ; } ;
    mine = resource : resource { init = scripts : scripts.name ; salt = 1 ; show = false ; use-output = true ; } ;
    name = resource : resource { init = scripts : scripts.name ; show = true ; use-output = true ; } ;
    test =
      {
        locks =
          {
            alpha = resource : resource { init = scripts : scripts.touch ; salt = scripts : scripts.test.util.locks.alpha ; permissions = 0600 ; show = false ; } ;
            beta= resource : resource { init = scripts : scripts.touch ; salt = scripts : scripts.test.util.locks.beta ; permissions = 0600 ; show = false ; } ;
          } ;
        resources =
          {
            alpha = resource : resource { init = scripts : scripts.test.util.resource.alpha.file ; release = scripts : scripts.test.util.resource.alpha.release ; salt = 1 ; } ;
            beta-1 = resource : resource { init = scripts : scripts.test.util.resource.beta-1.file ; release = scripts : scripts.test.util.resource.beta-1.release ; salt = scripts : scripts.test.util.resource.beta-1.salt ; } ;
            beta-2 = resource : resource { init = scripts : scripts.test.util.resource.beta-2.file ; release = scripts : scripts.test.util.resource.beta-2.release ; salt = scripts : scripts.test.util.resource.beta-2.salt ; } ;
            gamma-1 = resource : resource { init = scripts : scripts.test.util.resource.gamma-1.file ; release = scripts : scripts.test.util.resource.gamma-1.release ; salt = scripts : scripts.test.util.resource.gamma-1.salt ; } ;
            gamma-2 = resource : resource { init = scripts : scripts.test.util.resource.gamma-2.file ; release = scripts : scripts.test.util.resource.gamma-2.release ; salt = scripts : scripts.test.util.resource.gamma-2.salt ; } ;
          } ;
      } ;
  }