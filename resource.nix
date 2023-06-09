{ bash-variable , coreutils , flock , global , init , make-directory , permissions , structure-directory , pre-salt , salt , show , type } :
  ''
    HASH=$( ${ coreutils }/bin/echo ${ pre-salt } ${ salt } | ${ coreutils }/bin/md5sum | ${ coreutils }/bin/cut --bytes -32 ) &&
    if [ ! -d ${ structure-directory }/resource/${ bash-variable "HASH" } ]
    then
      ${ coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable "HASH" }
    fi &&
    exec ${ global.numbers.test }<>${ structure-directory }/resource/${ bash-variable "HASH" }/lock &&
    ${ flock }/bin/flock ${ global.numbers.test } &&
    if [ ! -f ${ structure-directory }/resource/${ bash-variable "HASH" }/exists ]
    then
      # This is a ${ type }
      ${ if make-directory then "${ coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable "HASH" }/resource" else "# NO NEED TO MAKE DIRECTORY" } &&
      ${ if make-directory then "cd ${ structure-directory }/resource/${ bash-variable "HASH" }/resource" else "# NO NEED TO cd" } &&
      ${ init } &&
      ${ coreutils }/bin/chmod ${ permissions } ${ structure-directory }/resource/${ bash-variable "HASH" }/resource &&
      ${ coreutils }/bin/touch ${ structure-directory }/resource/${ bash-variable "HASH" }/exists &&
      ${ coreutils }/bin/chmod 0400 ${ structure-directory }/resource/${ bash-variable "HASH" }/exists
    fi &&
    ${ coreutils }/bin/${ show } ${ structure-directory }/resource/${ bash-variable "HASH" }/resource
  ''