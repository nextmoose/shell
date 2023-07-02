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
      { bash-variable , coreutils , cowsay , dev , shell-scripts } :
        ''
          CRON=$( ${ dev.sudo } ${ coreutils }/bin/mktemp ${ dev.cron }/XXXXXXXX ) &&
          cleanup ( )
          {
            ${ dev.sudo } ${ coreutils }/bin/rm ${ bash-variable "CRON" }
          } &&
          trap cleanup EXIT &&
          (
            ${ coreutils }/bin/cat <<EOF
          * * * * *   $( ${ coreutils }/bin/whoami )   ${ coreutils }/bin/nice --adjustment 19 ${ shell-scripts.structure.cron.log }
          * * * * *   $( ${ coreutils }/bin/whoami )   ${ coreutils }/bin/nice --adjustment 19 ${ shell-scripts.structure.cron.resource }
          * * * * *   $( ${ coreutils }/bin/whoami )   ${ coreutils }/bin/nice --adjustment 19 ${ shell-scripts.structure.cron.temporary }
          EOF
          ) | ${ dev.sudo } ${ coreutils }/bin/tee ${ bash-variable "CRON" } &&
          ${ dev.sudo } ${ coreutils }/bin/chmod 0644 ${ bash-variable "CRON" } &&
          ${ cowsay }/bin/cowsay Hello 2> ${ dev.null }
        '' ;
    mine =
      { coreutils , log , resources , temporary } :
        ''
          ${ coreutils }/bin/echo HELLO WORLD > ${ temporary }/hello &&
          ${ coreutils }/bin/echo HELLO WORLD > ${ log "1f18b5d3-bcda-464d-ae28-8a55b5fd460a" } &&
          ${ coreutils }/bin/echo ${ resources.mine }
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
        cron =
          {
            alpha =
              { bash-variable , coreutils } :
                ''
                  ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 60 * 24 * 7 * 1 ) ) / ( 60 * 60 * 24 * 7 * 4 ) ))
                '' ;
            beta =
              { bash-variable , coreutils } :
                ''
                  ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 60 * 24 * 7 * 3 ) ) / ( 60 * 60 * 24 * 7 * 4 ) ))
                '' ;
            read =
              { bash-variable , coreutils , flock , global , resources } :
                ''
                  WEEK=$( ${ coreutils }/bin/echo $(( ( ( ${ bash-variable global.variables.timestamp } + ( 60 * 60 * 24 & 7 * 2 ) ) / ( 60 * 60 * 24 * 7 ) ) % 4  )) &&
                  if [ ${ bash-variable "WEEK" } -lt 2 ]
                  then
                    exec 201<>${ resources.cron.alpha } &&
                    ${ flock }/bin/flock -s 201 &&
                    ${ coreutils }/bin/cat ${ resources.cron.alpha }
                  else
                    exec 201<>${ resources.cron .beta } &&
                    ${ flock }/bin/flock -s 201 &&
                    ${ coreutils }/bin/cat ${ resources.cron.beta }
                  fi
                '' ;
            write =
              { bash-variable , coreutils , flock , resources } :
                ''
                  exec 201<>${ resources.cron.alpha } &&
                  ${ flock }/bin/flock 201 &&
                  exec 202<>${ resources.cron.beta } &&
                  ${ flock }/bin/flock 202 &&
                  ${ coreutils }/bin/cat ${ bash-variable 1 } >> ${ resources.cron.alpha } &&
                  ${ coreutils }/bin/cat ${ bash-variable 1 } >> ${ resources.cron.beta }
                '' ;
            log =
              { flock , resources , shell-scripts } :
                ''
                  exec 201<>${ resources.cron.log.jq } &&
                  ${ flock }/bin/flock 201 &&
                  exec 202<>${ resources.cron.log.log } &&
                  ${ flock }/bin/flock 201 &&
                  ${ shell-scripts.structure.release.temporary.directory } ${ resources.cron.log.log } ${ resources.cron.log.jq }
                '' ;
            resource =
              { shell-scripts , temporary } :
                ''
                  ${ shell-scripts.structure.release.temporary.directory } ${ temporary }/c &&
                  ${ shell-scripts.structure.cron.resource-alpha } ${ temporary }/c
                '' ;
            resource-alpha =
              { bash-variable , coreutils , flock , resources , shell-scripts } :
                ''
                  exec 201<>${ resources.cron.resource } &&
                  ${ flock }/bin/flock 201 &&
                  ${ coreutils }/bin/cat ${ bash-variable 1 } >> ${ resources.cron.resource }
                '' ;
            temporary =
              { flock , resources , shell-scripts } :
                ''
                  exec 201<>${ resources.cron.temporary } &&
                  ${ flock }/bin/flock 201 &&
                  ${ shell-scripts.structure.release.temporary.directory } ${ resources.cron.temporary }
                '' ;
          } ;
        release =
          {
            log =
              {
                directory =
                  { bash-variable , coreutils , findutils , flock , gnused , local , shell-scripts , structure-directory , yq } :
                    ''
                      if [ -d ${ structure-directory }/log ]
                      then
                        exec ${ local.numbers.log-directory }<>${ structure-directory }/log/lock &&
                        ${ flock }/bin/flock -s ${ local.numbers.log-directory } &&
                        ${ findutils }/bin/find ${ structure-directory }/log -mindepth 1 -maxdepth 1 -type d -name "????????" -exec ${ shell-scripts.structure.release.log.dir } {} \; | ${ yq }/bin/yq --yaml-output "sort_by(.timestamp,.script,.key)"
                      fi
                    '' ;
                dir =
                 { bash-variable , coreutils , findutils , flock , local , shell-scripts , yq } :
                   ''
                     exec ${ local.numbers.log-dir }<>${ bash-variable 1 }/lock &&
                     ${ flock }/bin/flock -n ${ local.numbers.log-dir } &&
                     ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -maxdepth 1 -name "*.*.log" -type f -name "*.*" -exec ${ shell-scripts.structure.release.log.file } {} ${ bash-variable 1 } \; | ${ yq }/bin/yq --yaml-output "flatten | sort_by(.timestamp,.script,.key)" &&
                     ${ coreutils }/bin/rm --recursive --force ${ bash-variable 1 }
                   '' ;
                 file =
                   { bash-variable , coreutils , gnused } :
                     ''
                       KEY=$( ${ coreutils }/bin/echo ${ bash-variable 1 } | ${ gnused }/bin/sed 's#^.*[.]\(.*\)[.].*#\1#' ) &&
                       ${ coreutils }/bin/echo "-" &&
                       ${ coreutils }/bin/echo "  script: \"$( ${ coreutils }/bin/cat ${ bash-variable 2 }/script.asc )\"" &&
                       ${ coreutils }/bin/echo "  key: ${ bash-variable "KEY" }" &&
                       ${ gnused }/bin/sed -e 's#^\([0-9]*.[0-9]*\) \(.*\)$#  timestamp: \1\n  value: >\n    \2#' ${ bash-variable 1 } &&
                       ${ coreutils }/bin/rm ${ bash-variable 1 }
                     '' ;
              } ;
            resource =
              {
                directory =
                  { bash-variable , coreutils , findutils , flock , hashes , global , local , shell-scripts , structure-directory , yq } :
                    ''
                      if [ -d ${ structure-directory }/resource ]
                      then
                        exec ${ local.numbers.resource-directory }<>${ structure-directory }/resource/lock &&
                        ${ flock }/bin/flock ${ local.numbers.resource-directory } &&
                        export ${ local.variables.timestamp }=$( ${ coreutils }/bin/date +%s ) &&
                        export ${ global.variables.timestamp }=$( ${ coreutils }/bin/date +%s ) &&
                        ${ coreutils }/bin/echo "timestamp:  ${ bash-variable global.variables.timestamp }" &&
                        ${ findutils }/bin/find ${ structure-directory }/resource -mindepth 1 -maxdepth 1 -type d ${ hashes } -exec ${ shell-scripts.structure.release.resource.dir } {} \; | ${ yq }/bin/yq --yaml-output "{resources:.}" | ${ yq }/bin/yq --yaml-output "{result:.}"
                      fi
                    '' ;
                dir =
                  { bash-variable , coreutils , dev , findutils , flock , global , gnused , shell-scripts , yq  } :
                    ''
                      if [ -d ${ bash-variable 1 } ]
                      then
                        exec ${ global.numbers.resource-dir }<>${ bash-variable 1 }/lock &&
                        ${ flock }/bin/flock ${ global.numbers.resource-dir } &&
                        ${ coreutils }/bin/echo "resource: \"$( ${ coreutils }/bin/cat ${ bash-variable 1 }/resource.asc )\"" &&
                        ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -maxdepth 1 -type f -name "*.invalidation" -exec ${ shell-scripts.structure.release.resource.invalidation } {} ${ bash-variable 0 } \; | ${ yq }/bin/yq --yaml-output "{invalidations:.}" &&
                        ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -maxdepth 1 -type f -name "*.pid" | while read PID_FILE
                        do
                          PID=$( ${ coreutils }/bin/cat ${ bash-variable "PID_FILE" } ) &&
                          ${ coreutils }/bin/echo ${ bash-variable "PID" } &&
                          ${ coreutils }/bin/tail --pid ${ bash-variable "PID" } --follow ${ dev.null } &&
                          ${ coreutils }/bin/rm ${ bash-variable "PID_FILE" }
                        done | ${ yq }/bin/yq --yaml-output "{pids:.}"
                        if [ -f ${ bash-variable 1 }/release.sh ]
                        then
                          ${ coreutils }/bin/echo "release: >" &&
                          ${ bash-variable 1 }/release.sh | ${ gnused }/bin/sed -e "s#^#  #"
                        else
                          ${ coreutils }/bin/echo "release: false"
                        fi
                      fi
                    '' ;
                invalidation =
                  { bash-variable , coreutils , findutils , gnugrep , shell-scripts , structure-directory , yq } :
                    ''
                      INVALIDATION_TOKEN=$( ${ coreutils }/bin/cat ${ bash-variable 1 } ) &&
                      INVALIDATOR=${ bash-variable 2 } &&
                      ${ findutils }/bin/find ${ structure-directory }/resource -mindepth 2 -maxdepth 2 -type l -name "init.sh" -exec ${ gnugrep }/bin/grep --with-filename ${ bash-variable "INVALIDATION_TOKEN" } {} \; | while read GREP
                      do
                        INVALIDATION_INIT=$( ${ coreutils }/bin/echo ${ bash-variable "GREP" } | ${ coreutils }/bin/cut --delimiter ":" --fields 1 ) &&
                        INVALIDATION_DIR=$( ${ coreutils }/bin/dirname ${ bash-variable "INVALIDATION_INIT" } ) &&
                        ${ bash-variable "INVALIDATOR" } ${ bash-variable "INVALIDATION_DIR" } ${ bash-variable 2 } &&
                        ${ coreutils }/bin/rm ${ bash-variable 1 }
                      done | ${ yq }/bin/yq --yaml-output "."
                    '' ;
              } ;
            temporary =
              {
                directory =
                  { bash-variable , coreutils , findutils , flock , yq , global , shell-scripts , structure-directory } :
                    ''
                      if [ -d ${ structure-directory }/temporary ]
                      then
                        exec ${ global.numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                        ${ flock }/bin/flock -s ${ global.numbers.temporary-directory } &&
                        ${ findutils }/bin/find ${ structure-directory }/temporary -mindepth 1 -maxdepth 1 -type d -exec ${ shell-scripts.structure.release.temporary.dir } {} \; | ${ yq }/bin/yq --yaml-output "sort"
                      fi
                    '' ;
                dir =
                  { bash-variable , coreutils , flock , local } :
                    ''
                      exec ${ local.numbers.temporary-dir }<>${ bash-variable 1 }/lock &&
                      ${ flock }/bin/flock -n ${ local.numbers.temporary-dir } &&
                      ${ coreutils }/bin/echo "- \"$( ${ coreutils }/bin/cat ${ bash-variable 1 }/script.asc )\"" &&
                      ${ coreutils }/bin/rm --recursive --force ${ bash-variable 1 } &&
                      ${ coreutils }/bin/true
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
          { coreutils , dev , gnused , shell-scripts , temporary , yq } :
            let
              result =
                {
                  setup =
                    {
                      alpha= "6cf25357-b934-48d2-bb32-f24266667c9a" ;
                      beta = "3be7473e-c335-4102-a8fd-f68b643014a0" ;
                      gamma = "6cf25357-b934-48d2-bb32-f24266667c9a 3be7473e-c335-4102-a8fd-f68b643014a0" ;
                      temporary =
                        {
                          err = null ;
                          out =
                            [
                              "{ test } { util } { resource } { alpha } { file }"
                              "{ test } { util } { resource } { beta } { file }"
                              "{ test } { util } { resource } { beta } { salt }"
                              "{ test } { util } { resource } { beta } { salt }"
                              "{ test } { util } { resource } { gamma } { file }"
                              "{ test } { util } { resource } { gamma } { salt }"
                            ] ;
                        } ;
                      log =
                        {
                          err = null ;
                          out =
                            [
                              {
                                script = "{ test } { util } { resource } { alpha } { file }" ;
                                key = "d020cdc7f37c8659eb3a5144d69a1c246cdbac59f995764999fbe50787d71202c8eed03e9d9811df608fd86801429a92904697510a7d54619e248503e1d3715d" ;
                                value = "299781ba-a761-443f-a256-2e5eb84c1808" ;
                              }
                              {
                                script = "{ test } { util } { resource } { beta } { salt }" ;
                                key = "ac44b84ed88eb4fb8df8f3ca55ef96b74db05cb7a18d80cd8c226223c32cace6efa95184389a6e0aa923a7662d9e942d8fe803b24afb87661428eacbf710af6e" ;
                                value = "d4332c59-13a7-40ff-afd5-f9e39a77e306" ;
                              }
			      {
                                script = "{ test } { util } { resource } { beta } { file }" ;
                                key = "e40d1ab0e28155cc7007538dc29ea80f14ede84ffb3fb99bcd480a85e63c360f7cef0bf84932bda6dea8a668186267199c3e9492e54904de7953d74c3b89b764" ;
                                value = "2cff5545-719e-4dde-af83-0605176a70c4" ;
                              }
                              {
                                script = "{ test } { util } { resource } { gamma } { salt }" ;
                                key = "4e2621c558ecfa2055e7a18e45b4a0e485e931e86ba0a68deae112e26f8fdee06867faa97a7b4781c1d72b75bdb52ebb1388225ef170e93d05f143f5e39564f4" ;
                                value = "a12e653e-e7f7-4de1-91ce-a51153e9e52f" ;
                              }
                              {
                                script = "{ test } { util } { resource } { beta } { salt }" ;
                                key = "ac44b84ed88eb4fb8df8f3ca55ef96b74db05cb7a18d80cd8c226223c32cace6efa95184389a6e0aa923a7662d9e942d8fe803b24afb87661428eacbf710af6e" ;
                                value = "d4332c59-13a7-40ff-afd5-f9e39a77e306" ;
                              }
			      {
                                script = "{ test } { util } { resource } { gamma } { file }" ;
                                key = "f93ec10213044c288c7e28a550b178d597cd36ed445bfa8eda51a1eaec16f32d345ddee8ea26603bcc18f30f6b159a750ce7c620d89af90e64d53d2a61920e6c" ;
                                value = "896b780d-8cc1-4dd4-b7b0-6ae020a1ac01" ;
                              }
                            ] ;
                        } ;
                    } ;
                  teardown =
                    {
                      resource =
                        {
                          err = null ;
                          out =
                            {
                              result =
                                {
                                  resources =
                                    {
                                      resource = "{ test } { resources } { alpha }" ;
                                      invalidations =
                                        {
                                          resource = "{ test } { resources } { gamma }" ;
                                          release = "e16a036f-9e55-4be8-aa81-72bb00fb3c58" ;
                                        } ;
                                      release = "1e733714-3ab1-4475-933c-53ecd415bead" ;
                                    } ;
                                } ; 
                              } ;
                        } ;
                      temporary =
                        {
                          err = null ;
                          out =
                            [
                              "{ test } { util } { resource } { alpha } { release }"
                              "{ test } { util } { resource } { beta } { salt }"
                              "{ test } { util } { resource } { beta } { salt }"
                              "{ test } { util } { resource } { gamma } { release }"
                              "{ test } { util } { resource } { gamma } { release }"
                              "{ test } { util } { resource } { gamma } { salt }"
                              "{ test } { util } { resource } { gamma } { salt }"
                            ] ;
                        } ;
                      log =
                        {
                          err = null ;
                          out =
                            [
                              {
                                script = "{ test } { util } { resource } { alpha } { file }" ;
                                key = "d020cdc7f37c8659eb3a5144d69a1c246cdbac59f995764999fbe50787d71202c8eed03e9d9811df608fd86801429a92904697510a7d54619e248503e1d3715d" ;
                                value = "299781ba-a761-443f-a256-2e5eb84c1808" ;
                              }
                              {
                                script = "{ test } { util } { resource } { beta } { salt }" ;
                                key = "ac44b84ed88eb4fb8df8f3ca55ef96b74db05cb7a18d80cd8c226223c32cace6efa95184389a6e0aa923a7662d9e942d8fe803b24afb87661428eacbf710af6e" ;
                                value = "d4332c59-13a7-40ff-afd5-f9e39a77e306" ;
                              }
                              {
                                script = "{ test } { util } { resource } { beta } { file }" ;
                                key = "e40d1ab0e28155cc7007538dc29ea80f14ede84ffb3fb99bcd480a85e63c360f7cef0bf84932bda6dea8a668186267199c3e9492e54904de7953d74c3b89b764" ;
                                value = "2cff5545-719e-4dde-af83-0605176a70c4" ;
                              }
                              {
                                script = "{ test } { util } { resource } { gamma } { salt }" ;
                                key = "4e2621c558ecfa2055e7a18e45b4a0e485e931e86ba0a68deae112e26f8fdee06867faa97a7b4781c1d72b75bdb52ebb1388225ef170e93d05f143f5e39564f4" ;
                                value = "a12e653e-e7f7-4de1-91ce-a51153e9e52f" ;
                              }
                              {
                                script = "{ test } { util } { resource } { beta } { salt }" ;
                                key = "ac44b84ed88eb4fb8df8f3ca55ef96b74db05cb7a18d80cd8c226223c32cace6efa95184389a6e0aa923a7662d9e942d8fe803b24afb87661428eacbf710af6e" ;
                                value = "d4332c59-13a7-40ff-afd5-f9e39a77e306" ;
                              }
                              {
                                script = "{ test } { util } { resource } { gamma } { file }" ;
                                key = "f93ec10213044c288c7e28a550b178d597cd36ed445bfa8eda51a1eaec16f32d345ddee8ea26603bcc18f30f6b159a750ce7c620d89af90e64d53d2a61920e6c" ;
                                value = "896b780d-8cc1-4dd4-b7b0-6ae020a1ac01" ;
                              }
                            ] ;
                         } ;
                    } ;
                } ;
              in
                ''
                  ${ shell-scripts.test.util.resource.setup } | ${ yq }/bin/yq --yaml-output "{setup:.}" > ${ temporary }/t0 &&
                  ${ coreutils }/bin/sleep 2s &&
                  ${ shell-scripts.test.util.resource.teardown } | ${ yq }/bin/yq --yaml-output "{teardown:.}" >> ${ temporary }/t0 &&
                  ${ gnused }/bin/sed \
                    -e 's#{ test } { util } { resource } { beta } { salt-1 }#{ test } { util } { resource } { beta } { salt }#' \
                    -e 's#{ test } { util } { resource } { beta } { salt-2 }#{ test } { util } { resource } { beta } { salt }#' \
                    -e 's#{ test } { util } { resource } { gamma } { salt-1 }#{ test } { util } { resource } { gamma } { salt }#' \
                    -e 's#{ test } { util } { resource } { gamma } { salt-2 }#{ test } { util } { resource } { gamma } { salt }#' \
                    -e 's#{ test } { util } { resource } { gamma } { file-1 }#{ test } { util } { resource } { gamma } { file }#' \
                    -e 's#{ test } { util } { resource } { gamma } { file-2 }#{ test } { util } { resource } { gamma } { file }#' \
                    -e 's#{ test } { resources } { gamma-1 }#{ test } { resources } { gamma }#' \
                    -e 's#{ test } { resources } { gamma-2 }#{ test } { resources } { gamma }#' \
                    -e "w${ temporary }/t1" \
                    ${ temporary }/t0 > ${ dev.null } &&
                  ${ yq }/bin/yq --yaml-output "{setup:{alpha:.setup.alpha,beta:.setup.beta,gamma:.setup.gamma,temporary:{err:.setup.temporary.err,out:.setup.temporary.out},log:{err:.setup.log.err,out:.setup.log.out|map({script:.script,key:.key,value:.value})}},teardown:{resource:{err:.teardown.resource.err,out:{result:{resources:{resource:.teardown.resource.out.result.resources.resource,invalidations:{resource:.teardown.resource.out.result.resources.invalidations.resource,release:.teardown.resource.out.result.resources.invalidations.release},release:.teardown.resource.out.result.resources.release}}}},temporary:{err:.teardown.temporary.err,out:.teardown.temporary.out},log:{err:.setup.log.err,out:.setup.log.out|map({script:.script,key:.key,value:.value})}}}" ${ temporary }/t1 > ${ temporary }/t2 &&
                  if [ $( ${ yq }/bin/yq --raw-output '. == ${ builtins.toJSON result }' ${ temporary }/t2 ) == true ]
                  then
                    ${ yq }/bin/yq --yaml-output "." ${ temporary }/t0
                  else
                    ${ yq }/bin/yq --yaml-output '{observed:.,expected:${ builtins.toJSON result }}' ${ temporary }/t2 &&
                    exit 64
                  fi
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
                  { bash-variable , coreutils , findutils , structure-directory } :
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
                          ${ coreutils }/bin/echo -n 6cf25357-b934-48d2-bb32-f24266667c9a > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo -n 31d64c0f-777e-480a-88a2-6772fa44e801 > ${ temporary }/4c3eefc2-3c42-4a1f-b30e-73318d0a6c16 &&
                          ${ coreutils }/bin/echo -n 299781ba-a761-443f-a256-2e5eb84c1808 > ${ log "b2323076-91b9-48c6-899d-290864fff828" }
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n 1e733714-3ab1-4475-933c-53ecd415bead &&
                          ${ coreutils }/bin/echo -n 1f02f307-fc6a-490a-aea8-e89aa1bae770 > ${ temporary }/adb95592-37d5-404c-bf75-147091101152 &&
                          ${ coreutils }/bin/echo -n b25d9a99-3a63-44be-b4f4-d010efaa1779 > ${ log "d85c557e-a71f-4eb0-a6e4-99309aa6f68b" }
                        '' ;
                  } ;
                beta =
                  {
                    file =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n 3be7473e-c335-4102-a8fd-f68b643014a0 > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo -n 792d7940-4d42-426e-ad94-67cdd9f53d59 > ${ temporary }/4c3eefc2-3c42-4a1f-b30e-73318d0a6c16 &&
                          ${ coreutils }/bin/echo -n 2cff5545-719e-4dde-af83-0605176a70c4 > ${ log "fef3c013-7df3-4cb9-b117-067340b64f3b" }
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n 657ee7bd-9a7c-4d8a-b1ee-11ccbc2a36cb &&
                          ${ coreutils }/bin/echo -n 9f737ac5-fbee-445f-9bbf-e273ae9793b4 > ${ temporary }/4400c8b1-3560-498a-aa0b-56bfad5204da &&
                          ${ coreutils }/bin/echo -n 23934ef5-7e31-4ab1-9f8d-c28d4f530fd8 > ${ log "921188f8-3494-488f-adfc-4178e5b5c608" }
                        '' ;
                    salt-1 =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n $(( ( ${ bash-variable 1 } + ( 60 * 15 ) ) / ( 60 * 60 ) )) &&
                          ${ coreutils }/bin/echo -n ee5bcfa3-50ea-4297-8864-7813f0ed0e99 > ${ temporary }/5d7ec497-ac05-4788-9d67-445d5a3bef6e &&
                          ${ coreutils }/bin/echo -n d4332c59-13a7-40ff-afd5-f9e39a77e306 > ${ log "9f8e5ead-8d44-492c-8842-628ae3be773e" }
                        '' ;
                    salt-2 =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n $(( ( ${ bash-variable 1 } + ( 60 * 45 ) ) / ( 60 * 60 ) )) &&
                          ${ coreutils }/bin/echo -n ee5bcfa3-50ea-4297-8864-7813f0ed0e99 > ${ temporary }/5d7ec497-ac05-4788-9d67-445d5a3bef6e &&
                          ${ coreutils }/bin/echo -n d4332c59-13a7-40ff-afd5-f9e39a77e306 > ${ log "9f8e5ead-8d44-492c-8842-628ae3be773e" }
                        '' ;
                  } ;
                gamma =
                  {
                    file-1 =
                      { bash-variable , coreutils , log , resources , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n ${ resources.test.resources.alpha } ${ resources.test.resources.beta-1 } > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo -n 5d37daae-afd5-4717-bd89-3746c2f90dd2 > ${ temporary }/63abb11d-eedb-4500-8dd9-8fef3fb569e6 &&
                          ${ coreutils }/bin/echo -n 896b780d-8cc1-4dd4-b7b0-6ae020a1ac01 > ${ log "cce640ac-962e-4df3-80b9-7378ff2b5531" }
                        '' ;
                    file-2 =
                      { bash-variable , coreutils , log , resources , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n ${ resources.test.resources.alpha } ${ resources.test.resources.beta-2 } > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo -n 5d37daae-afd5-4717-bd89-3746c2f90dd2 > ${ temporary }/63abb11d-eedb-4500-8dd9-8fef3fb569e6 &&
                          ${ coreutils }/bin/echo -n 896b780d-8cc1-4dd4-b7b0-6ae020a1ac01 > ${ log "cce640ac-962e-4df3-80b9-7378ff2b5531" }
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n e16a036f-9e55-4be8-aa81-72bb00fb3c58 &&
                          ${ coreutils }/bin/echo -n 2e11aad3-ed4f-4ef2-8a4b-358bf2dae4b0 > ${ temporary }/339f1af4-179a-409b-b0b5-e9925fff3be4 &&
                          ${ coreutils }/bin/echo -n a3cbc1cd-4f00-4317-ad85-db998d3b2783 > ${ log "b05f75f7-59eb-4e9a-af0d-141b0bc672f6" }
                        '' ;
                    salt-1 =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n $(( ( ${ bash-variable 1 } + ( 60 * 15 ) ) / ( 60 * 60 ) )) &&
                          ${ coreutils }/bin/echo -n 508277a1-7d82-42fa-acaa-248c93a1b503 > ${ temporary }/38509095-2a0f-4f16-8b18-4fbc728badb5 &&
                          ${ coreutils }/bin/echo -n a12e653e-e7f7-4de1-91ce-a51153e9e52f > ${ log "80f3a9cc-69ff-44d9-9685-b174dfad35e9" }
                        '' ;
                    salt-2 =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo -n $(( ( ${ bash-variable 1 } + ( 60 * 45 ) ) / ( 60 * 60 ) )) &&
                          ${ coreutils }/bin/echo -n 508277a1-7d82-42fa-acaa-248c93a1b503 > ${ temporary }/38509095-2a0f-4f16-8b18-4fbc728badb5 &&
                          ${ coreutils }/bin/echo -n a12e653e-e7f7-4de1-91ce-a51153e9e52f > ${ log "80f3a9cc-69ff-44d9-9685-b174dfad35e9" }
                        '' ;
                  } ;
                setup =
                  { bash-variable , coreutils , diffutils , findutils , flock , global , gnused , jq , resources , shell-scripts , structure-directory , strip , yq } :
                    ''
                      MINUTE=$(( ( ( ${ bash-variable global.variables.timestamp } + ( 60 * 15 ) ) / 60 ) % 60 )) &&
                      ${ coreutils }/bin/echo minute: ${ bash-variable "MINUTE" } &&
                      ${ coreutils }/bin/echo alpha: ${ resources.test.resources.alpha } &&
                      if [ ${ bash-variable "MINUTE" } -lt 30 ]
                      then
                        ${ coreutils }/bin/echo beta: ${ resources.test.resources.beta-1 } &&
                        ${ coreutils }/bin/echo gamma: ${ resources.test.resources.gamma-1 }
                      else
                        ${ coreutils }/bin/echo beta: ${ resources.test.resources.beta-2 } &&
                        ${ coreutils }/bin/echo gamma: ${ resources.test.resources.gamma-2 }
                      fi &&
                      ( ${ shell-scripts.structure.release.temporary.directory } > >( ${ yq }/bin/yq --yaml-output "{out:.}" ) 2> >( ${ yq }/bin/yq --yaml-output "{err:.}" ) ) > >( ${ yq }/bin/yq --yaml-output {temporary:.} ) &&
                      ( ${ shell-scripts.structure.release.log.directory } > >( ${ yq }/bin/yq --yaml-output "{out:.}" ) 2> >( ${ yq }/bin/yq --yaml-output {err:.} ) ) > >( ${ yq }/bin/yq --yaml-output "{log:.}" )
                    '' ;
                teardown =
                  { coreutils , jq , shell-scripts , temporary , yq } :
                    ''
                      ( ${ shell-scripts.structure.release.resource.directory } > >( ${ yq }/bin/yq --yaml-output "{out:.}" ) 2> >( ${ yq }/bin/yq --yaml-output "{err:.}" ) ) > >( ${ yq }/bin/yq --yaml-output "{resource:.}" ) &&
                      ( ${ shell-scripts.structure.release.temporary.directory } > >( ${ yq }/bin/yq --yaml-output "{out:.}" ) 2> >( ${ yq }/bin/yq --yaml-output "{err:.}" ) ) > >( ${ yq }/bin/yq --yaml-output {temporary:.} ) &&
                      ( ${ shell-scripts.structure.release.log.directory } > >( ${ yq }/bin/yq --yaml-output "{out:.}" ) 2> >( ${ yq }/bin/yq --yaml-output {err:.} ) ) > >( ${ yq }/bin/yq --yaml-output "{log:.}" )
                    '' ;
              } ;
          } ;
      } ;
  }