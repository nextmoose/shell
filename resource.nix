{
  build ,
  err ,
  host ,
  hash ,
  null ,
  out ,
  private ,
  scripts ,
  shared ,
  structure-directory ,
  target ,
  timestamp ? "scripts/resource.nix"
} @ arguments : { init , release , salt , track } @ parameters :
  let
    bash-variable = builtins.import ./bash-variable.nix ;
    code = strip ( if builtins.typeOf parameters.track == "null" then isolated else shared ) ;
    command =
      ''
        $( ${ target.writeShellScript "resource" code } "${ bash-variable hash }" "${ bash-variable "!" }" )
      '' ;
    hash =
      let
        null = track : "# UNDEFINED HASH" ;
	string = track : track.input ;
	undefined = track : track.throw "6d622699-0361-4bbf-a5b1-35d016fc86ba" ;
        in visit { null = null ; string = string ; undefined = undefined ; } arguments.hash ;
    init =
      let
        lambda =
          track :
            ''
              ${ target.coreutils }/bin/ln --symbolic ${ track.input ( scripts arguments ( { shell-script } : shell-script ) ) } ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh &&
              ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh ${ bash-variable "RESOURCE_DIRECTORY" }/resource
            '' ;
        null =
	  track :
	    ''
	      # INIT IS UNDEFINED
	      ${ target.coreutils }/bin/true
	    '' ;
        undefined = track : track.throw "4f8998c1-8c82-4c19-8358-8131519b4667" ;
        in visit { lambda = lambda ; null = null ; undefined = undefined ; } parameters.init ;
    inject = builtins.import ./inject.nix ;
    isolated =
      ''
        INVALIDATION=${ bash-variable 1 } &&
        PID=${ bash-variable 2 } &&
        if [ ! -d ${ structure-directory } ]
        then
          ${ target.coreutils }/bin/mkdir ${ structure-directory }
        fi &&
        exec 201<>${ structure-directory }/lock &&
        ${ target.flock }/bin/flock -s 201 &&
        RESOURCE_DIRECTORY=$( ${ target.coreutils }/bin/mktemp --directory ${ structure-directory }/XXXXXXXX ) &&
        exec 203<>${ bash-variable "RESOURCE_DIRECTORY" }/lock &&
        ${ target.flock }/bin/flock 203 &&
        ${ strip init } &&
        ${ strip release } &&
	if [ ${ bash-variable "HASH" } ]
	then
	  INVALIDATION_FILE=$( ${ target.coreutils }/bin/mktemp --suffix ".invalidation" ${ bash-variable "RESOURCE_DIRECTORY" }/XXXXXXXX ) &&
	  ${ target.coreutils }/bin/echo ${ bash-variable "INVALIDATION" } > ${ bash-variable "INVALIDATION_FILE" } &&
	  ${ target.coreutils }/bin/chmod 0400 ${ bash-variable "INVALIDATION_FILE" }
	fi &&
	if [ ${ bash-variable "PID" } ]
	then
	  PID_FILE=$( ${ target.coreutils }/bin/mktemp --suffix ".pid" ${ bash-variable "RESOURCE_DIRECTORY" }/XXXXXXXX ) &&
	  ${ target.coreutils }/bin/echo ${ bash-variable "PID" } > ${ bash-variable "PID_FILE" } &&
	  ${ target.coreutils }/bin/chmod 0400 ${ bash-variable "PID_FILE" }
	fi &&
        ${ target.coreutils }/bin/echo ${ bash-variable "RESOURCE_DIRECTORY" }/resource
      '' ;
    pre-salt = builtins.hashString "sha512" ( builtins.concatStringsSep "" [ init release salt track ] ) ;
    release =
      let
        lambda =
          track :
            ''
              ${ target.coreutils }/bin/ln --symbolic ${ track.input ( scripts arguments ( { shell-script } : shell-script ) ) } ${ bash-variable "RESOURCE_DIRECTORY" }/release.sh
            '' ;
        null =
	  track :
	    ''
	      # RELEASE IS UNDEFINED
	      ${ target.coreutils }/bin/true
	    '' ;
        undefined = track : track.throw "4517bcc8-2574-44c2-afd5-828998dcdc03" ;
        in visit { lambda = lambda ; null = null ; undefined = undefined ; } parameters.release ;
    salt =
      let
        int = track : track.throw "a6230c8c-177f-4110-bdc1-a106b9833da4" ;
        lambda = track : track.input ( scripts arguments ) ( { shell-script } : shell-script ) ;
	null = track : "$(( ${ bash-variable "TIMESTAMP" } / ${ builtins.toString track.input } ))" ;
	undefined = track : track.throw "0bc8165d-9603-41a7-8d4c-b1eb5babae6c" ;
	in visit { int = int ; lambda = lambda ; null = null ; undefined = undefined ; } parameters.salt ;
    scripts = builtins.import ./scripts.nix ;
    shared =
      ''
        INVALIDATION=${ bash-variable 1 } &&
        PID=${ bash-variable 2 } &&
        if [ ! -d ${ structure-directory } ]
        then
          ${ target.coreutils }/bin/mkdir ${ structure-directory }
        fi &&
        exec 201<>${ structure-directory }/lock &&
        ${ target.flock }/bin/flock -s 201 &&
	export ${ hash }=$( ${ target.coreutils }/bin/echo ${ pre-salt } | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128 ) &&
        RESOURCE_DIRECTORY=${ structure-directory }/${ bash-variable hash } &&
	if [ ! -d ${ bash-variable "RESOURCE_DIRECTORY" } ]
	then
	  ${ target.coreutils }/bin/mkdir ${ bash-variable "RESOURCE_DIRECTORY" }
	fi &&
        exec 203<>${ bash-variable "RESOURCE_DIRECTORY" }/lock &&
        ${ target.flock }/bin/flock 203 &&
	if [ ! -L ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh ]
	then
          ${ strip init }
	fi &&
	if [ ! -L ${ bash-variable "RESOURCE_DIRECTORY" }/release.sh ]
	then
          ${ strip release }
	fi &&
	if [ ${ bash-variable "INVALIDATION" } ]
	then
	  INVALIDATION_FILE=$( ${ target.coreutils }/mktemp --suffix ".invalidation" ${ bash-variable "RESOURCE_DIRECTORY" }/XXXXXXXX ) &&
	  ${ target.coreutils }/bin/echo ${ bash-variable "INVALIDATION" } > ${ bash-variable "INVALIDATION_FILE" } &&
	  ${ target.coreutils }/bin/chmod 0400 ${ bash-variable "INVALIDATION_FILE" }
	fi &&
	if [ ${ bash-variable "PID" } ]
	then
	  PID_FILE=$( ${ target.coreutils }/bin/mktemp --suffix ".pid" ${ bash-variable "RESOURCE_DIRECTORY" }/XXXXXXXX ) &&
	  ${ target.coreutils }/bin/cat ${ bash-variable "PID" } > ${ bash-variable "PID_FILE" } &&
	  ${ target.coreutils }/bin/chmod 0400 ${ bash-variable "PID_FILE" }
	fi &&
        ${ target.coreutils }/bin/echo ${ bash-variable "RESOURCE_DIRECTORY" }/resource
      '' ;
    shell-scripts = scripts arguments ( { shell-script } : shell-script ) ;
    strip = builtins.import ./strip.nix ;
    track =
      let
        null = track : "" ;
	set = track : track.qualified-name ;
	undefined = track : track.throw "4062261c-d821-4634-96b8-693b0df00357" ;
	in visit { null = null ; set = set ; undefined = undefined ; } parameters.track ;
    try = builtins.import ./try.nix ;
    visit = builtins.import ./visit.nix ;
    in strip command
