  {
    alpha =
      { coreutils , log , temporary , resources , uuid } :
        ''
          ${ coreutils }/bin/echo 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99 &&
          ${ coreutils }/bin/date > ${ temporary }/date &&
          ${ coreutils }/bin/date > ${ log "test" } &&
          ${ coreutils }/bin/echo uuid=${ uuid } &&
          ${ coreutils }/bin/echo ${ resources.name } &&
          ${ coreutils }/bin/echo HELLO $( ${ coreutils }/bin/tee )
        '' ;
    entry =
      { cowsay , dev } :
        ''
          # 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99
          ${ cowsay }/bin/cowsay Hello 2> ${ dev.null }
        '' ;
    name =
      { init , git , strip } :
        ''
          ${ strip init } &&
          ${ git } config user.name
        '' ;
    structure =
      {
        resource =
          {
            show =
              {
                cat =
                  { coreutils , resource } :
                    ''
                      ${ coreutils }/bin/cat $( ${ resource } )
                    '' ;
                echo =
                  { coreutils , resource } :
                    ''
                      ${ coreutils }/bin/echo $( ${ resource } )
                    '' ;
              } ;
            main =
              { bash-variable , coreutils , file-descriptor-dir , flock , pre-salt , salt , show , strip , structure-directory } :
                ''
                  SALT=$( ${ coreutils }/bin/echo ${ pre-salt } ${ salt } | ${ coreutils }/bin/md5sum | ${ coreutils }/bin/cut --bytes -32 ) &&
                  if [ ! -d ${ structure-directory }/resource/${ bash-variable "SALT" } ]
                  then
                    ${ coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable "SALT" }
                  fi &&
                  exec ${ file-descriptor-dir }<>${ structure-directory }/resource/${ bash-variable "SALT" } &&
                  ${ flock } ${ file-descriptor-dir } &&
                  if [ ! -s ${ structure-directory }/resource/${ bash-variable "SALT" }/resource ]
                  then
                    ${ coreutils }/bin/true
                  fi &&
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
            main =
              { log , resource , script , strip , structure , track , temporary , uuid , writeShellScript } :
                ''
                  # ${ uuid }
                  # ${ builtins.toString track.index }
                  # ${ builtins.toString track.qualified-name }

                  ${ strip structure } &&

                  ${ strip temporary } &&

                  ${ strip log } &&

                  ${ strip resource } &&

                  exec ${ writeShellScript track.simple-name ( strip script ) }
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
                  export ${ timestamp }=$( ${ coreutils }/bin/date +s )
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
                  ${ flock }/bin/flock ${ file-descriptor-directory }
                '' ;
          } ;
      } ;
  }