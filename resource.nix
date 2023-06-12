{ bash-variable , coreutils , flock , global , hash , init , invalidation-token , make-directory , output , permissions , release , structure-directory , pre-salt , salt , show , type } :
  ''
    HASH=${ hash } &&
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
      ${ coreutils }/bin/ln --symbolic ${ init } ${ structure-directory }/resource/${ bash-variable "HASH" }/init.sh &&
      ${ structure-directory }/resource/${ bash-variable "HASH" }/init.sh ${ structure-directory }/resource/${ bash-variable "HASH" }/resource ${ if output then "> ${ structure-directory }/resource/${ bash-variable "HASH" }/resource" else "" } &&
      ${ coreutils }/bin/chmod ${ permissions } ${ structure-directory }/resource/${ bash-variable "HASH" }/resource &&
      ${ if builtins.typeOf release == "bool" then "# NO RELEASE" else "${ coreutils }/bin/ln --symbolic ${ release } ${ structure-directory }/resource/${ bash-variable "HASH" }/release.sh" } &&
      ${ coreutils }/bin/touch ${ structure-directory }/resource/${ bash-variable "HASH" }/make-directory &&
      ${ coreutils }/bin/chmod 0400 ${ structure-directory }/resource/${ bash-variable "HASH" }/make-directory &&
      ${ coreutils }/bin/touch ${ structure-directory }/resource/${ bash-variable "HASH" }/exists &&
      ${ coreutils }/bin/chmod 0400 ${ structure-directory }/resource/${ bash-variable "HASH" }/exists
    fi &&
    PARENT_PID_FILE=$( ${ coreutils }/bin/mktemp --suffix .pid ${ structure-directory }/resource/${ bash-variable "HASH" }/XXXXXXXX ) &&
    ${ coreutils }/bin/echo ${ bash-variable 2 } > ${ bash-variable "PARENT_PID_FILE" } &&
    ${ coreutils }/bin/chmod 0400 ${ bash-variable "PARENT_PID_FILE" } &&
    INVALIDATION_TOKEN_FILE=$( ${ coreutils }/bin/mktemp --dry-run --suffix .invalidation ${ structure-directory }/resource/${ bash-variable "HASH" }/XXXXXXXX ) &&
    ${ coreutils }/bin/echo ${ invalidation-token } > ${ bash-variable "INVALIDATION_TOKEN_FILE" } &&
    ${ coreutils }/bin/chmod 0400 ${ bash-variable "INVALIDATION_TOKEN_FILE" } &&
    ${ coreutils }/bin/${ show } ${ structure-directory }/resource/${ bash-variable "HASH" }/resource
  ''