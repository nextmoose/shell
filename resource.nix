bash-variable : file-descriptor : structure-directory : coreutils : flock : pre-salt : salt : init : show :
  ''
    HASH=$( ${ coreutils }/bin/echo ${ pre-salt } ${ salt } | ${ coreutils }/bin/md5sum | ${ coreutils }/bin/cut --bytes -32 ) &&
    if [ ! -d ${ structure-directory }/resource/${ bash-variable "HASH" } ]
    then
      ${ coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable "HASH" }
    fi &&
    exec ${ file-descriptor }<>${ structure-directory }/resource/${ bash-variable "HASH" }/lock &&
    ${ flock }/bin/flock ${ file-descriptor } &&
    if [ ! -f ${ structure-directory }/resource/${ bash-variable "HASH" }/exists ]
    then
      ${ coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable "HASH" }/temporary &&
      cd ${ structure-directory }/resource/${ bash-variable "HASH" }/temporary &&
      ${ init } &&
      ${ coreutils }/bin/touch ${ structure-directory }/resource/${ bash-variable "HASH" }/exists &&
      ${ coreutils }/bin/chmod ${ structure-directory }/resource/${ bash-variable "HASH" }/exists
    fi &&
    ${ coreutils }/bin/${ show } ${ structure-directory }/resource/${ bash-variable "HASH" }
  ''