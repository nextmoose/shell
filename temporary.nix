{
  build ,
  err ,
  host ,
  null ,
  out ,
  scripts ,
  structure-directory ,
  target 
} @ arguments : { init ? null , release ? null } :
  let
    bash-variable = builtins.import ./bash-variable.nix ;
    inject = builtins.import ./inject.nix ;
    script =
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
        TEMPORARY_DIRECTORY=$( ${ target.coreutils }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
        exec 203<>${ bash-variable "TEMPORARY_DIRECTORY" }/lock &&
        ${ target.flock }/bin/flock 203 &&
        ${ if builtins.typeOf init == "lambda" then "${ target.coreutils }/bin/ln --symbolic ${ init shell-scripts } ${ bash-variable "TEMPORARY_DIRECTORY" }/init.sh" else "# NO INIT" } &&
        ${ if builtins.typeOf release == "lambda" then "${ target.coreutils }/bin/ln --symbolic ${ release shell-scripts } ${ bash-variable "TEMPORARY_DIRECTORY" }/release.sh" else "# NO RELEASE" } &&
        ${ if builtins.typeOf init == "lambda" then "${ bash-variable "TEMPORARY_DIRECTORY" }/init.sh"  else "# NO INIT" } &&
        ${ target.coreutils }/bin/echo ${ bash-variable "TEMPORARY_DIRECTORY" }
      '' ;
    scripts = builtins.import ./scripts.nix ;
    shell-scripts = inject scripts arguments ( { shell-script } : shell-script ) ;
    in
      "$( ${ target.writeShellScript "temporary" script } )"