{
  build ,
  err ,
  host ,
  null ,
  out ,
  scripts ,
  structure-directory ,
  target 
} @ arguments : { init ? null , release ? null , salt ? null } @ parameters :
  let
    bash-variable = builtins.import ./bash-variable.nix ;
    code =
      ''
        if [ ! -d ${ structure-directory } ]
        then
          ${ target.coreutils }/bin/mkdir ${ structure-directory }
        fi &&
        exec 201<>${ structure-directory }/lock &&
        ${ target.flock }/bin/flock -s 201 &&
        if [ ! -d ${ structure-directory }/temporary ]
        then
          ${ target.coreutils }/bin/mkdir ${ structure-directory }/temporary
        fi &&
        exec 202<>${ structure-directory }/temporary/lockexi &&
        ${ target.flock }/bin/flock -s 202 &&
        RESOURCE_DIRECTORY=$( ${ target.coreutils }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
        exec 203<>${ bash-variable "TEMPORARY_DIRECTORY" }/lock &&
        ${ target.flock }/bin/flock 203 &&
	${ init } &&
	${ release } &&
	PID_FILE=$( ${ target.coreutils }/bin/mktemp --suffix .pid ${ bash-variable "RESOURCE_DIRECTORY" }/XXXXXXXX &&
	${ target.coreutils }/bin/echo ${ bash-variable 1 } > ${ bash-variable "PID_FILE" } &&
	${ target.coreutils }/bin/chmod 0400 ${ bash-variable "PID_FILE" } &&
        ${ target.coreutils }/bin/echo ${ bash-variable "TEMPORARY_DIRECTORY" }
      '' ;
    init =
      if builtins.typeOf parameters.init == "lambda" && builtins.length ( builtins.attrNames ( builtins.functionsArgs parameters.init ) ) == 0 then
        ''
	  ${ target.coreutils }/bin/ln --symbolic ${ inject script ( arguments // { lambda = parameters.init ; } ) } ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh &&
	  ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh ${ bash-variable "RESOURCE_DIRECTORY" }/resource
	''
      else if builtins.typeOf parameters.init == "lambda" then
        ''
	  ${ target.coreutils }/bin/ln --symbolic ${ init shell-scripts } ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh &&
	  ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh ${ bash-variable "RESOURCE_DIRECTORY" }/resource
	''
      else
        ''
	  # NO INIT
	'' ;
    release =
      if builtins.typeOf parameters.release == "lambda" && builtins.length ( builtins.attrNames ( builtins.functionArgs parameters.release ) ) == 0 then
        ''
	  ${ target.coreutils }/bin/ln --symbolic ${ inject script ( arguments // { lambda = parameters.release ; } ) } ${ bash-variable "RESOURCE_DIRECTORY" }/release.sh
	''
      else if builtins.typeOf parameters.release == "lambda" then
        ''
	  ${ target.coreutils }/bin/ln --symbolic ${ release shell-scripts } ${ bash-variable "RESOURCE_DIRECTORY" }/release.sh &&
	''
      else
        ''
	  # NO RELEASE
	'' ;
    inject = builtins.import ./inject.nix ;
    script = builtins.import ./script.nix ;
    scripts = builtins.import ./scripts.nix ;
    shell-scripts = inject scripts arguments ( { shell-script } : shell-script ) ;
    in
      "$( ${ target.writeShellScript "temporary" script } ${ bash-variable "!" } )"