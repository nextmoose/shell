  {
    alpha =
      { coreutils , log , temporary , resources , uuid } :
        ''
          ${ coreutils }/bin/echo 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99 &&
          ${ coreutils }/bin/date > ${ temporary }/date &&
          ${ coreutils }/bin/date > ${ log "test" } &&
          ${ coreutils }/bin/echo uuid=${ uuid } &&
          ${ coreutils }/bin/echo OUTPUT BASED RESOURCE ${ resources.name } &&
          ${ coreutils }/bin/echo FILE BASED RESOURCE ${ resources.identity } &&
          ${ coreutils }/bin/echo HELLO $( ${ coreutils }/bin/tee )
        '' ;
    entry =
      { shell-scripts , cowsay , dev } :
        ''
          # 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99
          ${ cowsay }/bin/cowsay Hello 2> ${ dev.null }
        '' ;
    name =
      { git } :
        ''
          ${ git }/bin/git config user.name
        '' ;
    ssh =
      {
        identity =
          { bash-variable , coreutils , log , resources , openssh , temporary } :
            ''
              ${ openssh }/bin/ssh-keygen -f ${ temporary }/id-rsa -P "" -C "" > ${ log "ssh-keygen" } &&
              ${ coreutils }/bin/cat ${ temporary }/id-rsa > ${ bash-variable 1 } &&
              ${ coreutils }/bin/chmod 0400 ${ bash-variable 1 }
            '' ;
      } ;
    touch =
      { bash-variable , coreutils } :
        ''
          ${ coreutils }/bin/touch ${ bash-variable 1 }
        '' ;
    structure =
      {
        release =
          {
            log =
              {
                directory =
                  { bash-variable , coreutils , findutils , flock , gnused , local , shell-scripts , structure-directory } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE LOG >> ${ bash-variable 2 } &&
                      if [ -d ${ structure-directory }/log ]
                      then
                        exec ${ local.numbers.log-directory }<>${ structure-directory }/log/lock &&
                        ${ flock }/bin/flock -s ${ local.numbers.log-directory } &&
                        ${ coreutils }/bin/echo BEGIN LOCK RELEASE LOG >> ${ bash-variable 2 } &&
                        ${ findutils }/bin/find ${ structure-directory }/log -mindepth 1 -maxdepth 1 -type d -name "????????" -exec ${ shell-scripts.structure.release.log.dir } {} ${ bash-variable 1 } ${ bash-variable 2 } \;
                        fi &&
                      ${ coreutils }/bin/echo END RELEASE LOG >> ${ bash-variable 2 }
                    '' ;
                dir =
                 { bash-variable , coreutils , findutils , flock , local , shell-scripts } :
                   ''
                     ${ coreutils }/bin/echo BEGIN RELEASE LOG ${ bash-variable 1 } >> ${ bash-variable 3 } &&
                     exec ${ local.numbers.log-dir }<>${ bash-variable 1 }/lock &&
                     ${ flock }/bin/flock -n ${ local.numbers.log-dir } &&
                     ${ coreutils }/bin/echo BEGIN LOCK RELEASE LOG ${ bash-variable 1 } >> ${ bash-variable 3 } &&
                     ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -maxdepth 1 -name "*.*" -type f -exec ${ shell-scripts.structure.release.log.file } {} ${ bash-variable 2 } ${ bash-variable 3 } \; &&
                     ${ coreutils }/bin/rm --recursive --force ${ bash-variable 1 } &&
                     ${ coreutils }/bin/echo END RELEASE LOG ${ bash-variable 1 } >> ${ bash-variable 3 }
                   '' ;
                 file =
                   { bash-variable , coreutils , gnused } :
                     ''
                       ${ coreutils }/bin/echo BEGIN RELEASE FILE ${ bash-variable 1 } >> ${ bash-variable 3 } &&
                       EXTENSION=${ bash-variable "1##*." } &&
                       ${ coreutils }/bin/echo "${ bash-variable "EXTENSION" }:" >> ${ bash-variable 2 } &&
                       ${ gnused }/bin/sed -e 's#^\([0-9]*.[0-9]*\) \(.*\)$#  -\n    timestamp: \1\n    value: >\n      \2#' ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                       ${ coreutils }/bin/rm ${ bash-variable 1 } &&
                       ${ coreutils }/bin/echo END RELEASE FILE ${ bash-variable 1 } >> ${ bash-variable 3 }
                     '' ;
              } ;
            resource =
              {
                directory =
                  { bash-variable , coreutils , findutils , flock , hashes , global , local , shell-scripts , structure-directory } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE RESOURCE >> ${ bash-variable 1 } &&
                      if [ -d ${ structure-directory }/resource ]
                      then
                        exec ${ local.numbers.resource-directory }<>${ structure-directory }/resource/lock &&
                        ${ flock }/bin/flock ${ local.numbers.resource-directory } &&
                        ${ coreutils }/bin/echo BEGIN LOCK RELEASE RESOURCE >> ${ bash-variable 1 } &&
                        export ${ local.variables.timestamp }=$( ${ coreutils }/bin/date +%s ) &&
                        export ${ global.variables.timestamp }=$( ${ coreutils }/bin/date +%s ) &&
                        ${ findutils }/bin/find ${ structure-directory }/resource -mindepth 1 -maxdepth 1 -type d ${ hashes } -exec ${ shell-scripts.structure.release.resource.dir } {} ${ bash-variable 1 } \;
                      fi &&
                      ${ coreutils }/bin/echo END RELEASE RESOURCE >> ${ bash-variable 1 }
                    '' ;
                dir =
                  { bash-variable , coreutils , findutils , flock , global , shell-scripts } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE RESOURCE ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                      if [ -d ${ bash-variable 1 } ]
                      then
                        exec ${ global.numbers.resource-dir }<>${ bash-variable 1 }/lock &&
                        ${ flock }/bin/flock ${ global.numbers.resource-dir } &&
                        ${ coreutils }/bin/echo BEGIN LOCK RELEASE RESOURCE ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                        ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -maxdepth 1 -type f -name "*.invalidation" -exec ${ shell-scripts.structure.release.resource.exclusion } {} ${ bash-variable 2 } \;
                      fi &&
                      ${ coreutils }/bin/echo END RELEASE ${ bash-variable 1 } >> ${ bash-variable 2 }
                    '' ;
                exclusion =
                  { bash-variable , coreutils , findutils , shell-scripts , structure-directory } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE EXCLUSION ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                      ${ findutils }/bin/find ${ structure-directory }/resource -mindepth 2 -maxdepth 2 -type s -name "init.sh" >> ${ bash-variable 2 } &&
                      ${ coreutils }/bin/echo END RELEASE EXCLUSION ${ bash-variable 1 } >> ${ bash-variable 2 }
                    '' ;
              } ;
            temporary =
              {
                directory =
                  { bash-variable , coreutils , findutils , flock , local , shell-scripts , structure-directory } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE TEMPORARY >> ${ bash-variable 1 } &&
                      if [ -d ${ structure-directory }/temporary ]
                      then
                        exec ${ local.numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                        ${ flock }/bin/flock -s ${ local.numbers.temporary-directory } &&
                        ${ coreutils }/bin/echo BEGIN LOCK RELEASE TEMPORARY >> ${ bash-variable 1 } &&
                        ${ findutils }/bin/find ${ structure-directory }/temporary -mindepth 1 -maxdepth 1 -type d -exec ${ shell-scripts.structure.release.temporary.dir } {} ${ bash-variable 1 } \;
                        ${ coreutils }/bin/echo END RELEASE TEMPORARY >> ${ bash-variable 1 }
                      fi &&
                      ${ coreutils }/bin/echo END RELEASE TEMPORARY >> ${ bash-variable 1 }
                    '' ;
                dir =
                  { bash-variable , coreutils , flock , local } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE TEMPORARY ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                      exec ${ local.numbers.temporary-dir }<>${ bash-variable 1 }/lock &&
                      ${ flock }/bin/flock -n ${ local.numbers.temporary-dir } &&
                      ${ coreutils }/bin/echo BEGIN LOCK RELEASE TEMPORARY ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                      ${ coreutils }/bin/rm --recursive --force ${ bash-variable 1 } &&
                      ${ coreutils }/bin/echo END RELEASE TEMPORARY ${ bash-variable 1 } >> ${ bash-variable 2 }
                    '' ;
              } ;
          } ;
        _resource =
          {
            main =
              { bash-variable , structure-directory } :
                ''
                  PARENT_TIMESTAMP=${ bash-variable 1 } &&
                  PARENT_PROCESS=${ bash-variable 2 } &&
                  PARENT_SALT=${ bash-variable 3 } &&
                  HASH=$( ${ bash-variable 4 } ${ bash-variable "PARENT_TIMESTAMP" } )&&
                  INIT=${ bash-variable 5 } &&
                  SHOW=${ bash-variable 6 } &&
                  if [ ! -d ${ structure-directory }/resource/${ bash-variable "HASH" } ]
                  then
                    ${ bash-variable "INIT" }
                  fi &&
                  ${ bash-variable "SHOW" } ${ structure-directory }/structure/${ bash-variable "HASH" }
                '' ;
          } ;
      } ;
    test =
      {
        entry =
          { cowsay , dev } :
            ''
              ${ cowsay }/bin/cowsay TESTING ENVIRONMENT 2> ${ dev.null }
            '' ;
        test-resource =
          { coreutils , dev , shell-scripts , temporary } :
            ''
              source ${ shell-scripts.test.util.spec.suite } &&
              trap cleanup EXIT &&
              ${ shell-scripts.test.util.resource.setup } &&
              ${ coreutils }/bin/true
            '' ;
        util =
          {
            locks =
              {
                alpha =
                  { bash-variable , coreutils } :
                    ''
                      ${ coreutils }/bin/echo $(( ( ${ bash-variable "1" } + ( 60 * 15 ) ) / ( 60 * 60 ) ))
                    '' ;
                beta =
                  { bash-variable , coreutils } :
                    ''
                     ${ coreutils }/bin/echo $(( ( ${ bash-variable "1" } + ( 60 * 45 ) ) / ( 60 * 60 ) ))
                    '' ;
              } ;
            sleep =
              { flock , global , resources } :
                ''
                  exec 201<>${ resources.test.locks.alpha } &&
                  ${ flock }/bin/flock 201 &&
                  exec 202<>${ resources.test.locks.beta } &&
                  ${ flock }/bin/flock 202
                '' ;
            spec =
              {
                bad =
                  { bash-variable , coreutils } :
                    ''
                      ${ coreutils }/bin/echo BAD:  ${ bash-variable "@" } &&
                      exit 64
                    '' ;
                good =
                  { bash-variable , coreutils } :
                    ''
                      ${ coreutils }/bin/echo GOOD:  ${ bash-variable "@" }
                    '' ;
                suite =
                  { bash-variable , coreutils } :
                    ''
                      function cleanup ( )
                      {
                        if [ ${ bash-variable "?" } == 0 ]
                        then
                          ${ coreutils }/bin/echo PASSED
                        else
                          ${ coreutils }/bin/echo FAILED ${ bash-variable "?" } &&
                          exit 65
                        fi
                      }
                    '' ;
              } ;
            resource =
              {
                alpha =
                  {
                    file =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 6cf25357-b934-48d2-bb32-f24266667c9a > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo 299781ba-a761-443f-a256-2e5eb84c1808 > ${ log "b2323076-91b9-48c6-899d-290864fff828" } &&
                          ${ coreutils }/bin/echo 31d64c0f-777e-480a-88a2-6772fa44e801 > ${ temporary }/4c3eefc2-3c42-4a1f-b30e-73318d0a6c16
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo b25d9a99-3a63-44be-b4f4-d010efaa1779 > ${ log "d85c557e-a71f-4eb0-a6e4-99309aa6f68b" } &&
                          ${ coreutils }/bin/echo 1f02f307-fc6a-490a-aea8-e89aa1bae770 > ${ temporary }/adb95592-37d5-404c-bf75-147091101152    
                        '' ;
                  } ;
                beta-1 =
                  {
                    file =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 3be7473e-c335-4102-a8fd-f68b643014a0 > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo 2cff5545-719e-4dde-af83-0605176a70c4 > ${ log "fef3c013-7df3-4cb9-b117-067340b64f3b" } &&
                          ${ coreutils }/bin/echo 792d7940-4d42-426e-ad94-67cdd9f53d59 > ${ temporary }/4c3eefc2-3c42-4a1f-b30e-73318d0a6c16
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 23934ef5-7e31-4ab1-9f8d-c28d4f530fd8 > ${ log "9f737ac5-fbee-445f-9bbf-e273ae9793b4" } &&
                          ${ coreutils }/bin/echo 9f737ac5-fbee-445f-9bbf-e273ae9793b4 > ${ temporary }/4400c8b1-3560-498a-aa0b-56bfad5204da
                        '' ;
                    salt =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo d4332c59-13a7-40ff-afd5-f9e39a77e306 > ${ log "80f3a9cc-69ff-44d9-9685-b174dfad35e9" } &&
                          ${ coreutils }/bin/echo ee5bcfa3-50ea-4297-8864-7813f0ed0e99 > ${ temporary }/5d7ec497-ac05-4788-9d67-445d5a3bef6e &&
                          ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 15 ) ) / ( 60 * 60 ) ))
                        '' ;
                  } ;
                beta-2 =
                  {
                    file =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 3be7473e-c335-4102-a8fd-f68b643014a0 > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo 2cff5545-719e-4dde-af83-0605176a70c4 > ${ log "fef3c013-7df3-4cb9-b117-067340b64f3b" } &&
                          ${ coreutils }/bin/echo 792d7940-4d42-426e-ad94-67cdd9f53d59 > ${ temporary }/4c3eefc2-3c42-4a1f-b30e-73318d0a6c16
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 23934ef5-7e31-4ab1-9f8d-c28d4f530fd8 > ${ log "9f737ac5-fbee-445f-9bbf-e273ae9793b4" } &&
                          ${ coreutils }/bin/echo 9f737ac5-fbee-445f-9bbf-e273ae9793b4 > ${ temporary }/4400c8b1-3560-498a-aa0b-56bfad5204da
                        '' ;
                    salt =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo d4332c59-13a7-40ff-afd5-f9e39a77e306 > ${ log "80f3a9cc-69ff-44d9-9685-b174dfad35e9" } &&
                          ${ coreutils }/bin/echo ee5bcfa3-50ea-4297-8864-7813f0ed0e99 > ${ temporary }/5d7ec497-ac05-4788-9d67-445d5a3bef6e &&
                          ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 45 ) ) / ( 60 * 60 ) ))
                        '' ;
                  } ;
                gamma-1 =
                  {
                    file =
                      { bash-variable , coreutils , log , resources , temporary } :
                        ''
                          ${ coreutils }/bin/echo ${ resources.test.resources.alpha } ${ resources.test.resources.beta-1 } > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo 2cff5545-719e-4dde-af83-0605176a70c4 > ${ log "fef3c013-7df3-4cb9-b117-067340b64f3b" } &&
                          ${ coreutils }/bin/echo 792d7940-4d42-426e-ad94-67cdd9f53d59 > ${ temporary }/4c3eefc2-3c42-4a1f-b30e-73318d0a6c16
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 23934ef5-7e31-4ab1-9f8d-c28d4f530fd8 > ${ log "9f737ac5-fbee-445f-9bbf-e273ae9793b4" } &&
                          ${ coreutils }/bin/echo 9f737ac5-fbee-445f-9bbf-e273ae9793b4 > ${ temporary }/4400c8b1-3560-498a-aa0b-56bfad5204da
                        '' ;
                    salt =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo d4332c59-13a7-40ff-afd5-f9e39a77e306 > ${ log "80f3a9cc-69ff-44d9-9685-b174dfad35e9" } &&
                          ${ coreutils }/bin/echo ee5bcfa3-50ea-4297-8864-7813f0ed0e99 > ${ temporary }/5d7ec497-ac05-4788-9d67-445d5a3bef6e &&
                          ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 15 ) ) / ( 60 * 60 ) ))
                        '' ;
                  } ;
                gamma-2 =
                  {
                    file =
                      { bash-variable , coreutils , log , resources , temporary } :
                        ''
                          ${ coreutils }/bin/echo ${ resources.test.resources.alpha } ${ resources.test.resources.beta-1 } > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo 2cff5545-719e-4dde-af83-0605176a70c4 > ${ log "fef3c013-7df3-4cb9-b117-067340b64f3b" } &&
                          ${ coreutils }/bin/echo 792d7940-4d42-426e-ad94-67cdd9f53d59 > ${ temporary }/4c3eefc2-3c42-4a1f-b30e-73318d0a6c16
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 23934ef5-7e31-4ab1-9f8d-c28d4f530fd8 > ${ log "9f737ac5-fbee-445f-9bbf-e273ae9793b4" } &&
                          ${ coreutils }/bin/echo 9f737ac5-fbee-445f-9bbf-e273ae9793b4 > ${ temporary }/4400c8b1-3560-498a-aa0b-56bfad5204da
                        '' ;
                    salt =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo d4332c59-13a7-40ff-afd5-f9e39a77e306 > ${ log "80f3a9cc-69ff-44d9-9685-b174dfad35e9" } &&
                          ${ coreutils }/bin/echo ee5bcfa3-50ea-4297-8864-7813f0ed0e99 > ${ temporary }/5d7ec497-ac05-4788-9d67-445d5a3bef6e &&
                          ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 45 ) ) / ( 60 * 60 ) ))
                        '' ;
                  } ;
                setup =
                  { bash-variable , coreutils , diffutils , findutils , flock , global , gnused , resources , shell-scripts , temporary , structure-directory , strip , yq } :
                    let
                      in
                        ''
                          MINUTE=$(( ( ( ${ bash-variable global.variables.timestamp } + ( 60 * 15 ) ) / 60 ) % 60 )) &&
                          if [ "${ resources.test.resources.alpha }" == "6cf25357-b934-48d2-bb32-f24266667c9a" ]
                          then
                            ${ shell-scripts.test.util.spec.good } ALPHA resource matched expected
                          else
                            ${ shell-scripts.test.util.spec.bad } "ALPHA resource did not match expected \"${ resources.test.resources.alpha }\""
                          fi &&
                          if [ ${ bash-variable "MINUTE" } -lt 30 ]
                          then
                            if [ "${ resources.test.resources.beta-1 }" == "3be7473e-c335-4102-a8fd-f68b643014a0" ]
                            then
                              ${ shell-scripts.test.util.spec.good } BETA resource matched expected
                            else
                              ${ shell-scripts.test.util.spec.bad } "BETA resource did not match expected \"${ resources.test.resources.beta-1 }\""
                            fi &&
                            if [ "${ resources.test.resources.gamma-1 }" == "6cf25357-b934-48d2-bb32-f24266667c9a 3be7473e-c335-4102-a8fd-f68b643014a0" ]
                            then
                              ${ shell-scripts.test.util.spec.good } GAMMA resource matched expected
                            else
                              ${ shell-scripts.test.util.spec.bad } "GAMMA resource did not match expected \"${ resources.test.resources.gamma-1 }\""
                            fi
                          else
                            if [ "${ resources.test.resources.beta-2}" == "3be7473e-c335-4102-a8fd-f68b643014a0" ]
                            then
                              ${ shell-scripts.test.util.spec.good } BETA resource matched expected
                            else
                              ${ shell-scripts.test.util.spec.bad } "BETA resource did not match expected \"${ resources.test.resources.beta-2 }\""
                            fi &&
                            if [ "${ resources.test.resources.gamma-2 }" == "6cf25357-b934-48d2-bb32-f24266667c9a 3be7473e-c335-4102-a8fd-f68b643014a0" ]
                            then
                              ${ shell-scripts.test.util.spec.good } GAMMA resource matched expected
                            else
                              ${ shell-scripts.test.util.spec.bad } "GAMMA resource did not match expected \"${ resources.test.resources.gamma-1 }\""
                            fi
                          fi
                          ${ shell-scripts.structure.release.temporary.directory } ${ temporary }/caa > ${ temporary }/cab 2> ${ temporary }/cac &&
			  ${ shell-scripts.test.util.spec.good } release temporary is good &&
			  if [ ! -s ${ temporary }/cab ]
			  then
			    ${ shell-scripts.test.util.spec.good } release temporary did not out
			  else
			    ${ shell-scripts.test.util.spec.bad } release temporary outed
			  fi &&
			  if [ ! -s ${ temporary }/cac ]
			  then
			    ${ shell-scripts.test.util.spec.good } release temporary did not error
			  else
			    ${ shell-scripts.test.util.spec.bad } release temporary errored
			  fi &&
			  ${ shell-scripts.structure.release.log.directory } ${ temporary }/cba ${ temporary }/cbb > ${ temporary }/cbc 2> ${ temporary }/cbd &&
			  ${ shell-scripts.test.util.spec.good } release log is good &&
			  if [ ! -s ${ temporary }/cbc ]
			  then
			    ${ shell-scripts.test.util.spec.good } release log did not out
			  else
			    ${ shell-scripts.test.util.spec.bad } release log outed
			  fi &&
			  if [ ! -s ${ temporary }/cbd ]
			  then
			    ${ shell-scripts.test.util.spec.good } release log did not error
			  else
			    ${ shell-scripts.test.util.spec.bad } release log errored
			  fi &&
                          ${ coreutils }/bin/true
                        '' ;
              } ;
          } ;
      } ;
  }