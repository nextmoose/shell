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
              { bash-variable , coreutils , file-descriptor-directory , file-descriptor-dir , findutils , flock , gnused , resources , structure-directory } :
                ''
		  export TIMESTAMP=$( ${ coreutils }/bin/date +%s ) &&
                  exec 200<>${ resources.log.lock } &&
                  ${ flock }/bin/flock 200 &&
                  if [ -d ${ structure-directory }/log ]
                  then
                    exec ${ file-descriptor-directory }<>${ structure-directory }/log/lock &&
                    ${ flock }/bin/flock -s ${ file-descriptor-directory } &&
                    ${ findutils }/bin/find ${ structure-directory }/log -mindepth 1 -maxdepth 1 -type d | while read DIR
                    do
                      exec ${ file-descriptor-dir }<>${ bash-variable "DIR" }/lock &&
                      ${ flock }/bin/flock -n ${ file-descriptor-dir } &&
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
              { bash-variable , coreutils , file-descriptor-directory , file-descriptor-dir , findutils , flock , structure-directory } :
                ''
                  if [ -d ${ structure-directory }/temporary ]
                  then
                    exec ${ file-descriptor-directory }<>${ structure-directory }/temporary/lock &&
                    ${ flock }/bin/flock -s ${ file-descriptor-directory } &&
                    ${ findutils }/bin/find ${ structure-directory }/temporary -mindepth 1 -maxdepth 1 -type d | while read DIR
                    do
                      exec ${ file-descriptor-dir }<>${ bash-variable "DIR" }/lock &&
                      ${ flock }/bin/flock -n ${ file-descriptor-dir } &&
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
              { bash-variable , coreutils , file-descriptor-directory , file-descriptor-dir , flock , structure-directory , temporary-dir } :
                ''
                  # LOG
                  if [ ! -d ${ structure-directory }/log ]
                  then
                    ${ coreutils }/bin/mkdir ${ structure-directory }/log
                  fi &&
                  exec ${ file-descriptor-directory }<>${ structure-directory }/log/lock &&
                  ${ flock }/bin/flock -s ${ file-descriptor-directory } &&
                  export ${ temporary-dir }=$( ${ coreutils }/bin/mktemp --directory ${ structure-directory }/log/XXXXXXXX ) &&
                  exec ${ file-descriptor-dir }<>${ bash-variable temporary-dir }/lock &&
                  ${ flock }/bin/flock ${ file-descriptor-dir }
                '' ;
            main =
              { bash-variable , log , resource , script , strip , structure , track , temporary , uuid , writeShellScript } :
                ''
                  # ${ uuid }
                  # ${ builtins.toString track.index }
                  # ${ builtins.toString track.qualified-name }

                  ${ strip structure } &&

                  ${ strip temporary } &&

                  ${ strip log } &&

                  ${ strip resource } &&

                  exec ${ writeShellScript track.simple-name ( strip script ) } ${ bash-variable "@" }
                '' ;
            no =
              { label } :
                ''
                  # ${ label }
                '' ;
            resource =
              { bash-variable , coreutils , file-descriptor-directory , flock , structure-directory , timestamp } :
                ''         
                  # RESOURCE
                  if [ ! -d ${ structure-directory }/resource ]
                  then
                    ${ coreutils }/bin/mkdir ${ structure-directory }/resource
                  fi &&
                  exec ${ file-descriptor-directory }<>${ structure-directory }/resource/lock &&
                  ${ flock }/bin/flock -s ${ file-descriptor-directory } &&
                  export ${ timestamp }=$( ${ coreutils }/bin/date +%s )
                '' ;
            structure =
              { coreutils , file-descriptor , flock , structure-directory } :
                ''
                  # STRUCTURE
                  if [ ! -d ${ structure-directory } ]
                  then
                    ${ coreutils }/bin/mkdir ${ structure-directory }
                  fi &&
                  exec ${ file-descriptor }<>${ structure-directory }/lock &&
                  ${ flock }/bin/flock -s ${ file-descriptor }
                '' ;
            temporary =
              { bash-variable , coreutils , directory , file-descriptor-directory , file-descriptor-dir , flock , label , structure-directory , temporary-dir } :
                ''
                  # ${ label }
                  if [ ! -d ${ structure-directory }/${ directory } ]
                  then
                    ${ coreutils }/bin/mkdir ${ structure-directory }/${ directory }
                  fi &&
                  exec ${ file-descriptor-directory }<>${ structure-directory }/${ directory }/lock &&
                  ${ flock }/bin/flock -s ${ file-descriptor-directory } &&
                  export ${ temporary-dir }=$( ${ coreutils }/bin/mktemp --directory ${ structure-directory }/${ directory }/XXXXXXXX ) &&
                  exec ${ file-descriptor-dir }<>${ bash-variable temporary-dir }/lock &&
                  ${ flock }/bin/flock ${ file-descriptor-dir }
                '' ;
          } ;
      } ;
  }