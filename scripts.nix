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
		    exec 201<>${ resources.cron	.beta } &&
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
                  { bash-variable , coreutils , findutils , flock , gnused , local , shell-scripts , structure-directory } :
                    ''
		      ${ coreutils }/bin/echo "- " >> ${ bash-variable 1 } &&
		      ${ coreutils }/bin/echo "  type: release-log" >> ${ bash-variable 1 } &&
                      if [ -d ${ structure-directory }/log ]
                      then
                        exec ${ local.numbers.log-directory }<>${ structure-directory }/log/lock &&
                        ${ flock }/bin/flock -s ${ local.numbers.log-directory } &&
                        ${ findutils }/bin/find ${ structure-directory }/log -mindepth 1 -maxdepth 1 -type d -name "????????" -exec ${ shell-scripts.structure.release.log.dir } {} ${ bash-variable 1 } ${ bash-variable 2 } \;
                        fi
                    '' ;
                dir =
                 { bash-variable , coreutils , findutils , flock , local , shell-scripts } :
                   ''
                     exec ${ local.numbers.log-dir }<>${ bash-variable 1 }/lock &&
                     ${ flock }/bin/flock -n ${ local.numbers.log-dir } &&
                     ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -maxdepth 1 -name "*.*" -type f -exec ${ shell-scripts.structure.release.log.file } {} ${ bash-variable 2 } \; &&
                     ${ coreutils }/bin/rm --recursive --force ${ bash-variable 1 }
                   '' ;
                 file =
                   { bash-variable , coreutils , gnused } :
                     ''
                       KEY=${ bash-variable "1##*." } &&
                       ${ coreutils }/bin/echo "  -" >> ${ bash-variable 2 } &&
                       ${ coreutils }/bin/echo "    key: ${ bash-variable "KEY" }" >> ${ bash-variable 2 } &&
                       ${ gnused }/bin/sed -e 's#^\([0-9]*.[0-9]*\) \(.*\)$#    timestamp: \1\n    value: >\n    \2#' ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                       ${ coreutils }/bin/rm ${ bash-variable 1 }
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
                        ${ findutils }/bin/find ${ structure-directory }/resource -mindepth 1 -maxdepth 1 -type d ${ hashes } | while read RESOURCE
                        do
                          if [ -d ${ bash-variable "RESOURCE" } ]
                          then
                            ${ shell-scripts.structure.release.resource.dir } ${ bash-variable "RESOURCE" } ${ bash-variable 1 }
                          fi
                        done
                      fi &&
                      ${ coreutils }/bin/echo END RELEASE RESOURCE >> ${ bash-variable 1 }
                    '' ;
                dir =
                  { bash-variable , coreutils , dev , findutils , flock , global , shell-scripts } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE RESOURCE ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                      if [ -d ${ bash-variable 1 } ]
                      then
                        exec ${ global.numbers.resource-dir }<>${ bash-variable 1 }/lock &&
                        ${ flock }/bin/flock ${ global.numbers.resource-dir } &&
                        ${ coreutils }/bin/echo BEGIN LOCK RELEASE RESOURCE ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                        ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -maxdepth 1 -type f -name "*.invalidation" -exec ${ shell-scripts.structure.release.resource.invalidation } {} ${ bash-variable 2 } ${ bash-variable 0 } \; &&
                        ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -maxdepth 1 -type f -name "*.pid" | while read PID_FILE
                        do
                          ${ coreutils }/bin/echo PID_FILE=${ bash-variable "PID_FILE" } >> ${ bash-variable 2 } &&
                          PID=$( ${ coreutils }/bin/cat ${ bash-variable "PID_FILE" } ) &&
                          ${ coreutils }/bin/echo PID=${ bash-variable "PID" } >> ${ bash-variable 2 } &&
                          ${ coreutils }/bin/tail --pid ${ bash-variable "PID" } --follow ${ dev.null } &&
                          ${ coreutils }/bin/rm ${ bash-variable "PID_FILE" }
                        done &&
                        if [ -f ${ bash-variable 1 }/release.sh ]
                        then
                          ${ coreutils }/bin/echo THERE IS A DEFINED RELEASE ${ bash-variable 1 }/release.sh >> ${ bash-variable 2 }
                          ${ bash-variable 1 }/release.sh >> ${ bash-variable 2 } &&
                          ${ coreutils }/bin/echo WE USED A DEFINED RELEASE ${ bash-variable 1 }/release.sh >> ${ bash-variable 2 }
                        else
                          ${ coreutils }/bin/echo THERE IS NO DEFINED RELEASE >> ${ bash-variable 2 }
                        fi
                      fi &&
                      ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -type f -exec ${ coreutils }/bin/shred --force --remove {} \; &&
                      ${ coreutils }/bin/rm --recursive --force ${ bash-variable 1 } &&
                      ${ coreutils }/bin/echo END RELEASE ${ bash-variable 1 } >> ${ bash-variable 2 }
                    '' ;
                invalidation =
                  { bash-variable , coreutils , findutils , gnugrep , shell-scripts , structure-directory } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE INVALIDATION ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                      INVALIDATION_TOKEN=$( ${ coreutils }/bin/cat ${ bash-variable 1 } ) &&
                      ${ coreutils }/bin/echo WE WILL USE INVALIDATION_TOKEN ${ bash-variable "INVALIDATION_TOKEN" } >> ${ bash-variable 2 } &&
                      INVALIDATOR=${ bash-variable 3 } &&
                      ${ coreutils }/bin/echo WE WILL USE INVALIDATOR ${ bash-variable "INVALIDATOR" } &&
                      ${ findutils }/bin/find ${ structure-directory }/resource -mindepth 2 -maxdepth 2 -type l -name "init.sh" -exec ${ gnugrep }/bin/grep --with-filename ${ bash-variable "INVALIDATION_TOKEN" } {} \; | while read GREP
                      do
                        ${ coreutils }/bin/echo GREP=${ bash-variable "GREP" } &&
                        INVALIDATION_INIT=$( ${ coreutils }/bin/echo ${ bash-variable "GREP" } | ${ coreutils }/bin/cut --delimiter ":" --fields 1 ) &&
                        ${ coreutils }/bin/echo WE WILL USE INVALIDATION_INIT ${ bash-variable "INVALIDATION_INIT" }
                        INVALIDATION_DIR=$( ${ coreutils }/bin/dirname ${ bash-variable "INVALIDATION_INIT" } ) &&
                        ${ coreutils }/bin/echo WE WILL USE INVALIDATION_DIR ${ bash-variable "INVALIDATION_DIR" } &&
                        ${ coreutils }/bin/echo ${ bash-variable "INVALIDATOR" } ${ bash-variable "INVALIDATION_DIR" } ${ bash-variable 2 } >> ${ bash-variable 2 } &&
                        ${ bash-variable "INVALIDATOR" } ${ bash-variable "INVALIDATION_DIR" } ${ bash-variable 2 } &&
                        ${ coreutils }/bin/rm ${ bash-variable 1 }
                      done >> ${ bash-variable 2 } &&
                      ${ coreutils }/bin/echo END RELEASE EXCLUSION ${ bash-variable 1 } >> ${ bash-variable 2 }
                    '' ;
              } ;
            temporary =
              {
                directory =
                  { bash-variable , coreutils , findutils , flock , yq , global , shell-scripts , structure-directory , temporary } :
                    ''
		      exit 66 &&
		      ${ coreutils }/bin/echo "- " > ${ temporary }/result &&
		      ${ coreutils }/bin/echo "  type: release-temporary" >> ${ temporary }/result &&
		      ${ coreutils }/bin/echo "  scripts:" >> ${ temporary }/result &&
                      if [ -d ${ structure-directory }/temporary ]
                      then
                        exec ${ global.numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                        ${ flock }/bin/flock -s ${ global.numbers.temporary-directory } &&
                        # ${ findutils }/bin/find ${ structure-directory }/temporary -mindepth 1 -maxdepth 1 -type d -exec ${ shell-scripts.structure.release.temporary.dir } {} \; >> ${ temporary }/result
			${ coreutils }/bin/true
                      fi &&
		      # ${ yq }/bin/yq --yaml-output "{type: .type, scripts: .scripts|sort}" ${ temporary }/result
		      ${ coreutils }/bin/cat ${ temporary }/result }
                    '' ;
                dir =
                  { bash-variable , coreutils , flock , local } :
                    ''
                      exec ${ local.numbers.temporary-dir }<>${ bash-variable 1 }/lock &&
                      ${ flock }/bin/flock -n ${ local.numbers.temporary-dir } &&
		      ${ coreutils }/bin/echo "    - $( ${ coreutils }/bin/cat ${ bash-variable 1 }/index.asc )" &&
                      # ${ coreutils }/bin/rm --recursive --force ${ bash-variable 1 } &&
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
          { coreutils , dev , shell-scripts , temporary } :
            ''
              source ${ shell-scripts.test.util.spec.suite } &&
              trap cleanup EXIT &&
              ${ shell-scripts.test.util.resource.setup } &&
              ${ shell-scripts.test.util.resource.teardown }
            '' ;
        util =
          {
            enrich =
              { bash-variable , nodejs , temporary , yq } :
                let
                  enrich =
                    ''
                      const fs = require("fs");
                      const simplify = ( element, index, array ) => ({key : element.key, value : element.value.trim()}) ;
                      const resources = {
                        "a12e653e-e7f7-4de1-91ce-a51153e9e52f" : "alpha" ,
                        "b25d9a99-3a63-44be-b4f4-d010efaa1779": "alpha" ,
                        "2cff5545-719e-4dde-af83-0605176a70c4": "beta" ,
                        "23934ef5-7e31-4ab1-9f8d-c28d4f530fd8": "beta" ,
                        "d4332c59-13a7-40ff-afd5-f9e39a77e306": "beta" ,
                        "896b780d-8cc1-4dd4-b7b0-6ae020a1ac01": "gamma" ,
                        "a3cbc1cd-4f00-4317-ad85-db998d3b2783": "gamma" ,
                        "a12e653e-e7f7-4de1-91ce-a51153e9e52f": "gamma"
                      } ;
                      const methods = {
                        "a12e653e-e7f7-4de1-91ce-a51153e9e52f" : "init" ,
                        "b25d9a99-3a63-44be-b4f4-d010efaa1779": "release" ,
                        "2cff5545-719e-4dde-af83-0605176a70c4": "init" ,
                        "23934ef5-7e31-4ab1-9f8d-c28d4f530fd8": "release" ,
                        "d4332c59-13a7-40ff-afd5-f9e39a77e306": "salt" ,
                        "896b780d-8cc1-4dd4-b7b0-6ae020a1ac01": "init" ,
                        "a3cbc1cd-4f00-4317-ad85-db998d3b2783": "release" ,
                        "a12e653e-e7f7-4de1-91ce-a51153e9e52f": "salt"
                      } ;
		      const justifications =
		        {
			  setup : [
			    "this is the alpha init",
			    "this is the beta salt",
			    "this is the beta init",
			    "this is the gamma salt",
			    "this is the beta salt"
			    "this is the gamma init"
			  ] ,
                          teardown : [
                            "this is the first beta being salted for identification of resources to invalidate" ,
                            "this is the second beta being salted for identifcation of resources to invalidate" ,
                            "this is the first gamma being salted for identification of resources to invalidate" ,
                            "this is the second gamma being salted for identification of resources to invalidate" ,
                            "we have identified alpha for invalidation but we must first invalidate gamma" ,
                            "we are finally invalidating alpha"
			  ] ,
			} ;
		      const justify = ( index , array ) => {
		        if(array.length === justifications.setup.length) {
			  return justifications.setup[index] ;
			else if(array.length === justifications.teardown.length ) {
			  return justifications.teardown[index];
			}else {
			  return "" ;
			}
		      } ;
                      const resourcify = ( element , index , array ) => ({ index, key: element.key, value: element.value , resource:  resources[element.value] , justification: justifications[index] }) ;
                      fs.readFile(process.argv[2], "utf-8", (err, success) => console.log(JSON.stringify(JSON.parse(success).map(simplify).map(resourcify).map(methodify))));
                    '' ;
                  in
                    ''
                      ${ yq }/bin/yq "sort_by(.timestamp)" ${ bash-variable 1 } > ${ temporary }/data.json &&
                      ${ nodejs }/bin/node ${ builtins.toFile "enrich.js" enrich } ${ temporary }/data.json
                    '' ;
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
                          ${ coreutils }/bin/echo 6cf25357-b934-48d2-bb32-f24266667c9a > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo 31d64c0f-777e-480a-88a2-6772fa44e801 > ${ temporary }/4c3eefc2-3c42-4a1f-b30e-73318d0a6c16 &&
                          ${ coreutils }/bin/echo 299781ba-a761-443f-a256-2e5eb84c1808 > ${ log "b2323076-91b9-48c6-899d-290864fff828" }
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 1e733714-3ab1-4475-933c-53ecd415bead &&
                          ${ coreutils }/bin/echo 1f02f307-fc6a-490a-aea8-e89aa1bae770 > ${ temporary }/adb95592-37d5-404c-bf75-147091101152 &&
                          ${ coreutils }/bin/echo b25d9a99-3a63-44be-b4f4-d010efaa1779 > ${ log "d85c557e-a71f-4eb0-a6e4-99309aa6f68b" }
                        '' ;
                  } ;
                beta =
                  {
                    file =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 3be7473e-c335-4102-a8fd-f68b643014a0 > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo 792d7940-4d42-426e-ad94-67cdd9f53d59 > ${ temporary }/4c3eefc2-3c42-4a1f-b30e-73318d0a6c16 &&
                          ${ coreutils }/bin/echo 2cff5545-719e-4dde-af83-0605176a70c4 > ${ log "fef3c013-7df3-4cb9-b117-067340b64f3b" }
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo 657ee7bd-9a7c-4d8a-b1ee-11ccbc2a36cb &&
                          ${ coreutils }/bin/echo 9f737ac5-fbee-445f-9bbf-e273ae9793b4 > ${ temporary }/4400c8b1-3560-498a-aa0b-56bfad5204da &&
                          ${ coreutils }/bin/echo 23934ef5-7e31-4ab1-9f8d-c28d4f530fd8 > ${ log "921188f8-3494-488f-adfc-4178e5b5c608" }
                        '' ;
                    salt-1 =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 15 ) ) / ( 60 * 60 ) )) &&
                          ${ coreutils }/bin/echo ee5bcfa3-50ea-4297-8864-7813f0ed0e99 > ${ temporary }/5d7ec497-ac05-4788-9d67-445d5a3bef6e &&
                          ${ coreutils }/bin/echo d4332c59-13a7-40ff-afd5-f9e39a77e306 > ${ log "9f8e5ead-8d44-492c-8842-628ae3be773e" }
                        '' ;
                    salt-2 =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 45 ) ) / ( 60 * 60 ) )) &&
                          ${ coreutils }/bin/echo ee5bcfa3-50ea-4297-8864-7813f0ed0e99 > ${ temporary }/5d7ec497-ac05-4788-9d67-445d5a3bef6e &&
                          ${ coreutils }/bin/echo d4332c59-13a7-40ff-afd5-f9e39a77e306 > ${ log "9f8e5ead-8d44-492c-8842-628ae3be773e" }
                        '' ;
                  } ;
                gamma =
                  {
                    file =
                      { bash-variable , coreutils , log , resources , temporary } :
                        ''
                          ${ coreutils }/bin/echo ${ resources.test.resources.alpha } ${ resources.test.resources.beta-1 } > ${ bash-variable 1 } &&
                          ${ coreutils }/bin/echo 5d37daae-afd5-4717-bd89-3746c2f90dd2 > ${ temporary }/63abb11d-eedb-4500-8dd9-8fef3fb569e6 &&
                          ${ coreutils }/bin/echo 896b780d-8cc1-4dd4-b7b0-6ae020a1ac01 > ${ log "cce640ac-962e-4df3-80b9-7378ff2b5531" }
                        '' ;
                    release =
                      { coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo e16a036f-9e55-4be8-aa81-72bb00fb3c58 &&
                          ${ coreutils }/bin/echo 2e11aad3-ed4f-4ef2-8a4b-358bf2dae4b0 > ${ temporary }/339f1af4-179a-409b-b0b5-e9925fff3be4 &&
                          ${ coreutils }/bin/echo a3cbc1cd-4f00-4317-ad85-db998d3b2783 > ${ log "b05f75f7-59eb-4e9a-af0d-141b0bc672f6" }
                        '' ;
                    salt-1 =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 15 ) ) / ( 60 * 60 ) )) &&
                          ${ coreutils }/bin/echo 508277a1-7d82-42fa-acaa-248c93a1b503 > ${ temporary }/38509095-2a0f-4f16-8b18-4fbc728badb5 &&
                          ${ coreutils }/bin/echo a12e653e-e7f7-4de1-91ce-a51153e9e52f > ${ log "80f3a9cc-69ff-44d9-9685-b174dfad35e9" }
                        '' ;
                    salt-2 =
                      { bash-variable , coreutils , log , temporary } :
                        ''
                          ${ coreutils }/bin/echo $(( ( ${ bash-variable 1 } + ( 60 * 45 ) ) / ( 60 * 60 ) )) &&
                          ${ coreutils }/bin/echo 508277a1-7d82-42fa-acaa-248c93a1b503 > ${ temporary }/38509095-2a0f-4f16-8b18-4fbc728badb5 &&
                          ${ coreutils }/bin/echo a12e653e-e7f7-4de1-91ce-a51153e9e52f > ${ log "80f3a9cc-69ff-44d9-9685-b174dfad35e9" }
                        '' ;
                  } ;
                setup =
                  { bash-variable , coreutils , diffutils , findutils , flock , global , gnused , resources , shell-scripts , structure-directory , strip , temporary , yq } :
                    let
                      in
                        ''
                          MINUTE=$(( ( ( ${ bash-variable global.variables.timestamp } + ( 60 * 15 ) ) / 60 ) % 60 )) &&
			  ${ coreutils }/bin/echo alpha: ${ resources.test.resources.alpha } >> ${ temporary }/result &&
			  if [ ${ bash-variable "MINUTE" } -lt 30 ]
                          then
			    ${ coreutils }/bin/echo beta: ${ resources.test.resources.beta-1 } >> ${ temporary }/result &&
			    ${ coreutils }/bin/echo gamma: ${ resources.test.resources.gamma-1 } >> ${ temporary }/result
                          else
			    ${ coreutils }/bin/echo beta: ${ resources.test.resources.beta-2 } >> ${ temporary }/result &&
			    ${ coreutils }/bin/echo gamma: ${ resources.test.resources.gamma-2 } >> ${ temporary }/result
                          fi &&
			  ${ yq }/bin/yq --yaml-output "." ${ temporary }/result &&
                          ${ shell-scripts.structure.release.temporary.directory } > ${ temporary }/caaaa 2> ${ temporary }/caaba &&
			  ${ yq }/bin/yq --yaml-output "." ${ temporary }/caaaa &&
			  exit 66 &&
			  ${ yq } --yaml-output "." ${ temporary }/caaaa &&
			  if [ $( ${ yq }/bin/yq --raw-output "length" ${ temporary }/caaaa ) == 1 ]
			  then
			    ${ shell-scripts.test.util.spec.good } release temporary produced one record
			  else
			    ${ shell-scripts.test.util.spec.bad } release temporary produced the wrong number of records
			  fi &&
			  if [ $( ${ yq }/bin/yq --raw-output ".[0].type" ${ temporary }/caaaa ) == "release-temporary" ]
			  then
			    ${ shell-scripts.test.util.spec.good } release temporary produced a release-temporary record
			  else
			    ${ shell-scripts.test.util.spec.bad } release temporary produced the wrong type of record
			  fi &&
			  if [ $( ${ yq }/bin/yq --raw-output ".[0].directories | length" ${ temporary }/caaaa ) == 5 ]
			  then
			    ${ shell-scripts.test.util.spec.good } release temporary produced a release-temporary record
			  else
			    ${ shell-scripts.test.util.spec.bad } release temporary produced the wrong type of record
			  fi &&
			  if [ ! -s ${ temporary }/caaba ]
			  then
			    ${ shell-scripts.test.util.spec.good } release temporary did not output
			  else
			    ${ shell-scripts.test.util.spec.bad } release temporary outputed $( ${ coreutils }/bin/cat ${ temporary }/caaba )
			  fi &&
			  if [ ! -s ${ temporary }/caaca ]
			  then
			    ${ shell-scripts.test.util.spec.good } release temporary did not error
			  else
			    ${ shell-scripts.test.util.spec.bad } release temporary errored $( ${ coreutils }/bin/cat ${ temporary }/caaca )
			  fi &&
			  ${ shell-scripts.structure.release.log.directory } ${ temporary }/cbaaa > ${ temporary }/cbaba 2> ${ temporary }/cbaca &&
			  if [ ! -s ${ temporary }/cbaba ]
			  then
			    ${ shell-scripts.test.util.spec.good } release log did not output
			  else
			    ${ shell-scripts.test.util.spec.bad } release log outputed $( ${ coreutils }/bin/cat ${ temporary }/caaca )
			  fi &&
			  if [ ! -s ${ temporary }/cbaca ]
			  then
			    ${ shell-scripts.test.util.spec.good } release log did not error
			  else
			    ${ shell-scripts.test.util.spec.bad } release log errored $( ${ coreutils }/bin/cat ${ temporary }/cbaca )
			  fi
                        '' ;
                teardown =
                  { coreutils , jq , shell-scripts , temporary , yq } :
                    ''
                      ${ coreutils }/bin/echo SLEEP 2s &&
                      ${ coreutils }/bin/sleep 2s &&
                      ${ coreutils }/bin/echo SLEPT 2s &&
                      ${ shell-scripts.structure.release.resource.directory } ${ temporary }/ccba > ${ temporary }/ccbb 2> ${ temporary }/ccbc &&
                      ${ coreutils }/bin/echo REPAIR 02 &&
                      ${ shell-scripts.structure.release.temporary.directory } ${ temporary }/caba > ${ temporary }/cabb 2> ${ temporary }/cabc &&
                      ${ coreutils }/bin/echo REPAIR 03 &&
                      ${ shell-scripts.test.util.spec.good } release temporary is good &&
                      if [ ! -s ${ temporary }/cabb ]
                      then
                        ${ shell-scripts.test.util.spec.good } release temporary did not out
                      else
                        ${ shell-scripts.test.util.spec.bad } release temporary outed
                      fi &&
                      if [ ! -s ${ temporary }/cabc ]
                      then
                        ${ shell-scripts.test.util.spec.good } release temporary did not error
                      else
                        ${ shell-scripts.test.util.spec.bad } release temporary errored
                      fi &&
                      ${ shell-scripts.structure.release.temporary.directory } ${ temporary }/caba > ${ temporary }/cabb 2> ${ temporary }/cabc &&
                      ${ shell-scripts.structure.release.log.directory } ${ temporary }/cbba ${ temporary }/cbbb > ${ temporary }/cbbc 2> ${ temporary }/cbbd &&
                      ${ yq }/bin/yq --yaml-output "sort_by(.timestamp)" ${ temporary }/cbba &&
                      ${ shell-scripts.test.util.enrich } ${ temporary }/cbba > ${ temporary }/cbbab &&
                      ${ coreutils }/bin/cat ${ temporary }/cbbab &&
                      ${ jq }/bin/jq --raw-output ".[0].value" ${ temporary }/cbbab &&
                      if [ $( ${ jq }/bin/jq --raw-output ".[0].value" ${ temporary }/cbbab ) == "d4332c59-13a7-40ff-afd5-f9e39a77e306" ]
                      then
                        ${ shell-scripts.test.util.spec.good } the first logged item is the calculation of the first beta salt
                      else
                        ${ shell-scripts.test.util.spec.bad }
                      fi &&
                      if [ $( ${ jq }/bin/jq --raw-output ".[1].value" ${ temporary }/cbbab ) == "d4332c59-13a7-40ff-afd5-f9e39a77e306" ]
                      then
                        ${ shell-scripts.test.util.spec.good } the second logged item is the calculation of the second beta salt - the same as the first
                      else
                        ${ shell-scripts.test.util.spec.bad }
                      fi &&
                      if [ $( ${ jq }/bin/jq --raw-output ".[2].value" ${ temporary }/cbbab ) == "a12e653e-e7f7-4de1-91ce-a51153e9e52f" ]
                      then
                        ${ shell-scripts.test.util.spec.good } the third logged item is the calculation of the first gamma salt
                      else
                        ${ shell-scripts.test.util.spec.bad }
                      fi &&
                      if [ $( ${ jq }/bin/jq --raw-output ".[3].value" ${ temporary }/cbbab ) == "a12e653e-e7f7-4de1-91ce-a51153e9e52f" ]
                      then
                        ${ shell-scripts.test.util.spec.good } the fourth logged item is the calculation of the second gamma salt - the same as the first
                      else
                        ${ shell-scripts.test.util.spec.bad }
                      fi &&
                      if [ $( ${ jq }/bin/jq --raw-output ".[4].value" ${ temporary }/cbbab ) == "a3cbc1cd-4f00-4317-ad85-db998d3b2783" ]
                      then
                        ${ shell-scripts.test.util.spec.good } the fifth logged item is the gamma release
                      else
                        ${ shell-scripts.test.util.spec.bad }
                      fi &&
                      if [ $( ${ jq }/bin/jq --raw-output ".[5].value" ${ temporary }/cbbab ) == "b25d9a99-3a63-44be-b4f4-d010efaa1779" ]
                      then
                        ${ shell-scripts.test.util.spec.good } the sixth logged item is the alpha release, notice that the gamma release preceded the alpha release and the beta release never happened
                      else
                        ${ shell-scripts.test.util.spec.bad }
                      fi &&
                      if [ $( ${ jq }/bin/jq --raw-output "length" ${ temporary }/cbbab ) == "6" ]
                      then
                        ${ shell-scripts.test.util.spec.good } I have accounted for every log
                      else
                        ${ shell-scripts.test.util.spec.bad }
                      fi &&
                      # ${ coreutils }/bin/echo NEXT &&
                      # ${ yq }/bin/yq --yaml-output "sort_by(.timestamp)" ${ temporary }/cbba &&
                      # ${ coreutils }/bin/cat ${ temporary }/ccba
                      ${ coreutils }/bin/true
                    '' ;
              } ;
          } ;
      } ;
  }