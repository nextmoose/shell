{
  build ,
  err ,
  host ,
  hash ,
  null ,
  out ,
  path ,
  private ,
  process ,
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
        $( export ${ process }=${ bash-variable "!" } && ${ target.writeShellScript "resource" code } "${ bash-variable hash }" "${ bash-variable process }" )
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
              cleanup ( ) {
                EXIT_CODE=${ bash-variable "?" } &&
                  ${ target.coreutils }/bin/echo ${ bash-variable "EXIT_CODE" } > ${ bash-variable "RESOURCE_DIRECTORY" }/init.code &&
                  ${ target.coreutils }/bin/chmod 0400 ${ bash-variable "RESOURCE_DIRECTORY" }/init.code &&
                  if [ ${ bash-variable "EXIT_CODE" } == 0 ]
                  then
                    exit 0
                  else
                    exit 64
                  fi
              } &&
              trap cleanup EXIT &&
              ${ target.coreutils }/bin/cat ${ track.input ( scripts arguments ( { shell-script } : shell-script ) ) } > ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh &&
              ${ target.coreutils }/bin/touch --date @0 ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh &&
              ${ target.coreutils }/bin/chmod 0500 ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh &&
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
          ${ target.coreutils }/bin/mkdir --parents ${ structure-directory }
        fi &&
        exec 201<>${ structure-directory }/lock &&
        ${ target.flock }/bin/flock -s 201 &&
        RESOURCE_DIRECTORY=$( ${ target.coreutils }/bin/mktemp --directory ${ structure-directory }/XXXXXXXX ) &&
        export ${ path }=${ bash-variable "RESOURCE_DIRECTORY" }/resource &&
        exec 203<>${ bash-variable "RESOURCE_DIRECTORY" }/lock &&
        ${ target.flock }/bin/flock 203 &&
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
        ${ strip init } &&
        ${ target.coreutils }/bin/echo ${ bash-variable path }
      '' ;
    path =
      let
        null = track : "UNDEFINED PATH" ;
        string = track : track.input ;
        undefined = track : track.throw "ccd2062c-6607-4d89-8414-138a2f31edca" ;
        in visit { null = null ; string = string ; undefined = undefined ; } arguments.path ;
    pre-salt = builtins.hashString "sha512" ( builtins.concatStringsSep "" [ init release salt track ] ) ;
    process =
      let
        null = track : "UNDEFINED PROCESS" ;
        string = track : track.input ;
        undefined = track : track.throw "77a2498b-9ef9-42fc-8db7-5cfdfd7a6e20" ;
        in visit { null = null ; string = string ; undefined = undefined ; } arguments.process ;
    release =
      let
        lambda =
          track :
            ''
              ${ target.coreutils }/bin/cat ${ track.input ( scripts arguments ( { shell-script } : shell-script ) ) } > ${ bash-variable "RESOURCE_DIRECTORY" }/release.sh &&
              ${ target.coreutils }/bin/touch --date @0 ${ bash-variable "RESOURCE_DIRECTORY" }/release.sh &&
              ${ target.coreutils }/bin/chmod 0500 ${ bash-variable "RESOURCE_DIRECTORY" }/release.sh
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
        bool = track : "$(( ( ${ bash-variable 1 } + ( 60 * 60 * ( if track.input then 6 else 18 ) ) ) / ( ( 60 * 60 * 24 ) ) ))" ;
        int = track : "$(( ${ bash-variable 1 } / ${ builtins.toString track.input } ))" ;
        lambda = track : "$( ${ track.input ( scripts arguments ) ( { shell-script } : shell-script ) } ${ bash-variable 1 } )" ;
        null = track : "$(( ${ bash-variable 1 } / ( 60 * 60 * 24 * 7 ) ))" ;
        undefined = track : track.throw "0bc8165d-9603-41a7-8d4c-b1eb5babae6c" ;
        in visit { bool = bool ; int = int ; lambda = lambda ; null = null ; undefined = undefined ; } parameters.salt ;
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
        HASH_PROGRAM=${ target.writeShellScript "hash" "${ target.coreutils }/bin/echo ${ pre-salt } ${ salt } | ${ target.coreutils }/bin/sha512sum | ${ target.coreutils }/bin/cut --bytes -128  " } &&
        export ${ hash }=$( ${ bash-variable "HASH_PROGRAM" } ${ bash-variable timestamp } ) &&
        RESOURCE_DIRECTORY=${ structure-directory }/${ bash-variable hash } &&
        export ${ path }=${ bash-variable "RESOURCE_DIRECTORY" }/resource &&
        if [ -d ${ bash-variable "RESOURCE_DIRECTORY" } ]
        then
          if [ ${ bash-variable "HASH_PROGRAM" } != $( ${ target.coreutils }/bin/readlink ${ bash-variable "RESOURCE_DIRECTORY" }/hash.sh ) ]
          then
            ${ target.coreutils }/bin/echo HASH COLLISION DETECTED > ${ err } &&
              ${ target.coreutils }/bin/echo THIS CAN HAPPEN CORRECTLY IN THEORY > ${ err } &&
              ${ target.coreutils }/bin/echo BECAUSE MULTIPLE RESOURCES WILL MAP TO THE SAME HASH > ${ err } &&
              ${ target.coreutils }/bin/echo AND EVENTUALLY IT WILL HAPPEN > ${ err } &&
              ${ target.coreutils }/bin/echo BUT THE HASH SPACE IS SO VAST > ${ err } &&
              ${ target.coreutils }/bin/echo THAT IT IS MUCH MORE LIKELY > ${ err } &&
              ${ target.coreutils }/bin/echo TO BE A PROGRAM ERROR > ${ err } &&
              exit 64
          fi
        else
          ${ target.coreutils }/bin/mkdir ${ bash-variable "RESOURCE_DIRECTORY" } &&
          ${ target.coreutils }/bin/echo ${ target.coreutils }/bin/ln --symbolic ${ bash-variable "HASH_PROGRAM" } ${ bash-variable "RESOURCE_DIRECTORY" }/hash.sh > /tmp/debug &&
          ${ target.coreutils }/bin/ln --symbolic ${ bash-variable "HASH_PROGRAM" } ${ bash-variable "RESOURCE_DIRECTORY" }/hash.sh
        fi &&
        exec 203<>${ bash-variable "RESOURCE_DIRECTORY" }/lock &&
        ${ target.flock }/bin/flock 203 &&
        if [ ! -x ${ bash-variable "RESOURCE_DIRECTORY" }/release.sh ]
        then
          ${ strip release }
        fi &&
        if [ ! -x ${ bash-variable "RESOURCE_DIRECTORY" }/init.sh ]
        then
          ${ strip init }
        fi &&
        if [ ${ bash-variable "INVALIDATION" } ]
        then
          INVALIDATION_FILE=$( ${ target.coreutils }/bin/mktemp --suffix ".invalidation" ${ bash-variable "RESOURCE_DIRECTORY" }/XXXXXXXX ) &&
          ${ target.coreutils }/bin/echo ${ bash-variable "INVALIDATION" } > ${ bash-variable "INVALIDATION_FILE" } &&
          ${ target.coreutils }/bin/chmod 0400 ${ bash-variable "INVALIDATION_FILE" }
        fi &&
        if [ ${ bash-variable "PID" } ]
        then
          PID_FILE=$( ${ target.coreutils }/bin/mktemp --suffix ".pid" ${ bash-variable "RESOURCE_DIRECTORY" }/XXXXXXXX ) &&
          ${ target.coreutils }/bin/cat ${ bash-variable "PID" } > ${ bash-variable "PID_FILE" } &&
          ${ target.coreutils }/bin/chmod 0400 ${ bash-variable "PID_FILE" }
        fi &&
        ${ target.coreutils }/bin/echo ${ bash-variable path }
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
