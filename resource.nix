{ bash-variable , coreutils , flock , global , hash-files , init , jq , make-directory , permissions , release , structure-directory , pre-salt , salt , show , type } :
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
    ${ jq }/bin/jq --null-input --raw-output '${ hash-files } | map(select(.file=="${ bash-variable 2 }")) | map(.hash) | .[]' | while read PARENT_HASH_EXPRESSION
    do
      PARENT_HASH=$( ${ bash-variable "PARENT_HASH_EXPRESSION" } ) &&
      PARENT_HASH_FILE=$( ${ coreutils }/bin/mktemp --suffix .hash ${ structure-directory }/resource/${ bash-variable "HASH" }/XXXXXXXX ) &&
      ${ coreutils }/bin/echo ${ bash-variable "PARENT_HASH" } > ${ bash-variable "PARENT_HASH_FILE" }
      ${ coreutils }/bin/chmod 0400 ${ bash-variable "PARENT_HASH_FILE" }
    done &&
    PARENT_PID_FILE=$( ${ coreutils }/bin/mktemp --suffix .pid ${ structure-directory }/resource/${ bash-variable "HASH" }/XXXXXXXX ) &&
    ${ coreutils }/bin/echo ${ bash-variable 1 } > ${ bash-variable "PARENT_PID_FILE" } &&
    ${ coreutils }/bin/chmod 0400 ${ bash-variable "PARENT_PID_FILE" } &&
    ${ coreutils }/bin/${ show } ${ structure-directory }/resource/${ bash-variable "HASH" }/resource
  ''