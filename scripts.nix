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
    beta =
      { coreutils , release , resources } :
        ''
          ${ coreutils }/bin/echo Hello &&
          ${ release.temporary } &&
          ${ release.log }
        '' ;
    entry =
      { shell-scripts , cowsay , dev } :
        ''
          # 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99
          ${ cowsay }/bin/cowsay Hello 2> ${ dev.null }
        '' ;
    gamma =
      { coreutils , flock , release , resources } :
        ''
          ${ coreutils }/bin/echo HELLO &&
          ${ release.log } &&
	  exec 200<>${ resources.log.lock } &&
	  ${ flock }/bin/flock -s 200 &&
	  ${ coreutils }/bin/echo ${ resources.log.file }
        '' ;
    name =
      { init , git , strip } :
        ''
          ${ strip init } &&
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
        at =
	  { at , bash-variable , dev , coreutils } :
	    ''
	      ${ coreutils }/bin/echo ${ coreutils }/bin/nice --adjustment 19 ${ bash-variable "@" } | ${ at } now 2> ${ dev.null }
	    '' ;
        cron =
	  { bash-variable , coreutils , dev } :
            ''
	      CRON=$( ${ dev.sudo } { coreutils }/bin/mktemp ${ dev.cron }/XXXXXXXX ) &&
	      ${ coreutils }/echo ${ bash-variable 1 } ${ bash-variable 2 } > ${ bash-variable "CRON" } &&
	      ${ coreutils }/bin/echo ${ dev.sudo } ${ coreutils }/bin/rm ${ bash-variable "CRON" }
	    '' ;
        release =
          {
            log =
              { bash-variable , coreutils , findutils , flock , gnused , local , resources , structure-directory } :
                ''
		  export TIMESTAMP=$( ${ coreutils }/bin/date +%s ) &&
                  exec 200<>${ resources.log.lock } &&
                  ${ flock }/bin/flock 200 &&
                  if [ -d ${ structure-directory }/log ]
                  then
                    exec ${ local.numbers.log-directory }<>${ structure-directory }/log/lock &&
                    ${ flock }/bin/flock -s ${ local.numbers.log-directory } &&
                    ${ findutils }/bin/find ${ structure-directory }/log -mindepth 1 -maxdepth 1 -type d | while read DIR
                    do
                      exec ${ local.numbers.log-dir }<>${ bash-variable "DIR" }/lock &&
                      ${ flock }/bin/flock -n ${ local.numbers.log-dir } &&
                      ${ findutils }/bin/find ${ bash-variable "DIR" } -mindepth 1 -maxdepth 1 -type f -name "*.*" | while read FILE
                      do
                        ${ coreutils }/bin/stat --format "%W %n" ${ bash-variable "FILE" }
                      done | ${ coreutils }/bin/sort --key 1 --numeric | ${ coreutils }/bin/cut --delimiter " " --fields 2 | while read FILE
                      do
                        EXTENSION=${ bash-variable "FILE##*." } &&
			${ coreutils }/bin/echo "-" >> ${ resources.log.file } &&
                        ${ coreutils }/bin/echo "  ${ bash-variable "EXTENSION" }:" >> ${ resources.log.file } &&
                        ${ gnused }/bin/sed -e 's#^\([0-9]*.[0-9]*\) \(.*\)$#    -\n      timestamp: \1\n      value: >\n        \2#' ${ bash-variable "FILE" } >> ${ resources.log.file }
			${ coreutils }/bin/true
                      done &&
                      ${ coreutils }/bin/rm --recursive --force ${ bash-variable "DIR" }
                    done
                  fi
                '' ;
            temporary =
              { bash-variable , coreutils , findutils , flock , local , structure-directory } :
                ''
                  if [ -d ${ structure-directory }/temporary ]
                  then
                    exec ${ local.numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                    ${ flock }/bin/flock -s ${ local.numbers.temporary-directory } &&
                    ${ findutils }/bin/find ${ structure-directory }/temporary -mindepth 1 -maxdepth 1 -type d | while read DIR
                    do
                      exec ${ local.numbers.temporary-dir }<>${ bash-variable "DIR" }/lock &&
                      ${ flock }/bin/flock -n ${ local.numbers.temporary-dir } &&
                      ${ coreutils }/bin/rm --recursive --force ${ bash-variable "DIR" }
                    done
                  fi
                '' ;
          } ;
        resource =
          {
            show =
              {
                cat =
                  { coreutils , resource } :
                    ''
                      ${ coreutils }/bin/cat ${ resource }
                    '' ;
                echo =
                  { coreutils , resource } :
                    ''
                      ${ coreutils }/bin/echo ${ resource }
                    '' ;
              } ;
            main =
              { bash-variable , coreutils , file-descriptor-dir , flock , init , permissions , pre-salt , salt , show , strip , structure-directory } :
                ''
                  TIMESTAMP=${ bash-variable 1 } &&
                  PID=${ bash-variable 2 } &&
                  SALT=$( ${ coreutils }/bin/echo ${ pre-salt } ${ salt } | ${ coreutils }/bin/md5sum | ${ coreutils }/bin/cut --bytes -32 ) &&
		  ${ coreutils }/bin/echo '${ pre-salt }' - '${ salt }' - ${ bash-variable "TIMESTAMP" } - ${ bash-variable "SALT" } >> /tmp/repair &&
                  if [ ! -d ${ structure-directory }/resource/${ bash-variable "SALT" } ]
                  then
                    ${ coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable "SALT" }
                  fi &&
                  exec ${ file-descriptor-dir }<>${ structure-directory }/resource/${ bash-variable "SALT" }/lock &&
                  ${ flock }/bin/flock ${ file-descriptor-dir } &&
                  if [ ! -s ${ structure-directory }/resource/${ bash-variable "SALT" }/resource ]
                  then
                    ${ init } &&
                    ${ coreutils }/bin/chmod ${ permissions } ${ structure-directory }/resource/${ bash-variable "SALT" }/resource
                  fi &&
                  ${ coreutils }/bin/echo ${ bash-variable "PID" } > $( ${ coreutils }/bin/mktemp --suffix ".pid" ${ structure-directory }/resource/${ bash-variable "SALT" }/XXXXXXXX ) &&
                  ${ coreutils }/bin/echo ${ bash-variable "SALT" } > $( ${ coreutils }/bin/mktemp --suffix ".salt" ${ structure-directory }/resource/${ bash-variable "SALT" }/XXXXXXXX ) &&
                  ${ strip show }
                '' ;
          } ;
        script =
          {
            init =
              { bash-variable , coreutils , process , salt , timestamp } :
                ''         
                  # INIT
                  export ${ salt }=${ bash-variable 1 }
                  export ${ process }=${ bash-variable 2 }
                  export ${ timestamp }=${ bash-variable 3 }
                '' ;
             log =
	       {
	         no =
                  ''
                    # NO LOG
                  '' ;
		 yes =
                  { bash-variable , coreutils , flock , local , structure-directory } :
                    ''
                      # YES LOG
                      if [ ! -d ${ structure-directory }/log ]
                      then
                        ${ coreutils }/bin/mkdir ${ structure-directory }/log
                      fi &&
                      exec ${ local.numbers.log-directory }<>${ structure-directory }/log/lock &&
                      ${ flock }/bin/flock -s ${ local.numbers.log-directory } &&
                      export ${ local.variables.log-dir }=$( ${ coreutils }/bin/mktemp --directory ${ structure-directory }/log/XXXXXXXX ) &&
                      exec ${ local.numbers.log-dir }<>${ bash-variable local.variables.log-dir }/lock &&
                      ${ flock }/bin/flock ${ local.numbers.log-dir }
                    '' ;
	      } ;
            main =
              { bash-variable , local , track , temporary , uuid , writeShellScript } :
                ''
                  # ${ uuid }
                  # ${ builtins.toString track.index }
                  # ${ builtins.toString track.qualified-name }

                  ${ local.scripts.structure } &&

                  ${ local.scripts.temporary } &&

                  ${ local.scripts.log } &&

                  ${ local.scripts.resource } &&

                  exec ${ writeShellScript track.simple-name local.scripts.script } ${ bash-variable "@" }
                '' ;
            resource =
	      {
	         no =
                  ''
                    # NO RESOURCE
                  '' ;
		 yes =
                  { bash-variable , coreutils , flock , local , structure-directory } :
                    ''         
                      # RESOURCE
                      if [ ! -d ${ structure-directory }/resource ]
                      then
                        ${ coreutils }/bin/mkdir ${ structure-directory }/resource
                      fi &&
                      exec ${ local.numbers.resource-directory }<>${ structure-directory }/resource/lock &&
                      ${ flock }/bin/flock -s ${ local.numbers.resource-directory } &&
                      export ${ local.variables.timestamp }=$( ${ coreutils }/bin/date +%s )
                    '' ;
		} ;
            structure =
	      {
	         no =
                  ''
                    # NO STRUCTURE
                  '' ;
		 yes =
                  { bash-variable , coreutils , flock , local , structure-directory } :
                    ''         
                      # YES STRUCTURE
                      if [ ! -d ${ structure-directory } ]
                      then
                        ${ coreutils }/bin/mkdir ${ structure-directory }
                      fi &&
                      exec ${ local.numbers.structure-directory }<>${ structure-directory }/lock &&
                      ${ flock }/bin/flock -s ${ local.numbers.structure-directory }
                    '' ;
		} ;
             temporary =
	       {
	         no =
                  ''
                    # 1 NO TEMPORARY
                  '' ;
		 yes =
                  { bash-variable , coreutils , flock , local , structure-directory } :
                    ''
                      # YES TEMPORARY
                      if [ ! -d ${ structure-directory }/temporary ]
                      then
                        ${ coreutils }/bin/mkdir ${ structure-directory }/temporary
                      fi &&
                      exec ${ local.numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                      ${ flock }/bin/flock -s ${ local.numbers.temporary-directory } &&
                      export ${ local.variables.temporary-dir }=$( ${ coreutils }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                      exec ${ local.numbers.temporary-dir }<>${ bash-variable local.variables.temporary-dir }/lock &&
                      ${ flock }/bin/flock ${ local.numbers.temporary-dir }
                    '' ;
	      } ;
          } ;
      } ;
    test =
      {
        alpha =
	  { coreutils , temporary } :
	    ''
	      ${ coreutils }/bin/echo 0ce67836-04aa-4046-a14d-ba91d2677eb4 > ${ temporary }/f82a3997-0970-479e-ab5f-faf2e1b22854
	    '' ;
        delay =
	  { coreutils } :
	    ''
	      ${ coreutils }/bin/sleep 10s &&
	      ${ coreutils }/bin/2800dd15-d6c8-495e-94c1-bc0adb1118d7
	    '' ;
	entry =
	  { cowsay , dev } :
	    ''
	      ${ cowsay }/bin/cowsay TESTING 2> ${ dev.null }
	    '' ;
	file =
	  { bash-variable , coreutils } :
	    ''
	      ${ coreutils }/bin/echo 7eaa6251-82e0-47c7-b492-7ababc3e709b > ${ bash-variable 1 }
	    '' ;
        output =
	  { coreutils } :
	    ''
	      ${ coreutils }/bin/echo 2f7c0f5b-80f9-4b32-870a-3868702f0c18
	    '' ;
        testing =
	  { shell-scripts , coreutils , dev , findutils , flock , release , resources , structure-directory } :
	    ''
	      exec 200<>${ resources.test.lock } &&
	      ${ flock }/bin/flock 200 &&
	      ${ release.temporary }
	      ${ shell-scripts.test.alpha } &&
	      if [ $( ${ findutils }/bin/find ${ structure-directory }/temporary -name f82a3997-0970-479e-ab5f-faf2e1b22854 | ${ coreutils }/bin/wc --lines ) != 1 ]
	      then
	        ${ coreutils }/bin/echo We were expecting to find exactly one temporary file. &&
		exit 64
	      else
	        ${ coreutils }/bin/echo We found exactly one temporary file.
	      fi &&
	      ${ release.temporary }
	    '' ;
      } ;
  }