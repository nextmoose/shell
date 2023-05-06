 {
    inputs =
      {
        bash-variable.url = "/home/emory/projects/5juNXfpb" ;
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843" ;
        scripts.url = "/home/emory/projects/61EJI0cs" ;
        strip.url = "/home/emory/projects/0TFnR2fJ" ;
        try.url = "/home/emory/projects/0gG3HgHu" ;
        visit.url = "/home/emory/projects/wHpYNJk8" ;
      } ;
    outputs =
      { bash-variable , flake-utils , nixpkgs , self , scripts , strip , try , visit } :
        (
          {
            lib =
              let
                flakes = { nixpkgs = nixpkgs ; scripts = scripts ; try = try ; visit = visit ; } ;
                in
                  {
                    dev ? { null = "/dev/null" ; stdout = "/dev/stdout" ; } ,
                    hook ,
                    inputs ,
                    nixpkgs ? flakes.nixpkgs ,
                    resources ,
                    scripts ? flakes.scripts ,
                    structure-directory ? "/tmp/structure" ,
                    try ? flakes.try ,
                    visit ? flakes.visit
                  } :
                    flake-utils.lib.eachDefaultSystem
                      (
                        system :
                          {
                            devShell =
                              let
                                _hook =
                                  let
                                    lambda = track : track.reduced ( _scripts global ) { pathed = false ; simple-name = "hook" ; } ;
                                    undefined = track : track.throw "74478eda-a96c-4257-9f15-8e6edb3f753c" ;
                                    in visit.lib { lambda = lambda ; undefined = undefined ; } hook ;
                                _inputs =
                                  let
                                    list = track : track.reduced ;
                                    string = track : track.reduced ;
                                    undefined = track : track.throw "b4c6c730-4669-4e7d-b312-8950bbce4971" ;
                                    in visit.lib { list = list ; string = string ; undefined = undefined ; } ( inputs ( _scripts global ) ) ;
                                _resources =
                                  fun :
                                    let
                                      lambda =
                                        track :
                                          let
                                            resource =
                                              { init , name ? null , make-directory ? null , permission ? null , salt ? null , salted ? null , show ? false } : { persist ? null } :
                                                let
                                                  pre-salt = builtins.hashString "sha512" ( builtins.concatStringsSep "" ( builtins.map builtins.toString ( builtins.attrValues saltables ) ) );
                                                  program = pkgs.writeShellScript reduced.name script ;
                                                  reduced = saltables // unsaltables ;
                                                  saltables =
                                                    {
                                                      init =
                                                        let
                                                          lambda = track : track.reduced ( _scripts global ) { pathed = false ; } ;
                                                          null = track : "" ;
                                                          undefined = track : track.throw "a8a3bab5-90ce-4eac-bf03-e22ac62f0a78" ;
                                                          in visit.lib { lambda = lambda ; null = null ; undefined = undefined ; } init ;
                                                      make-directory =
                                                        let
                                                          bool = track : track.reduced ;
                                                          null = track : false ;
                                                          undefined = track : track.throw "cea2149e-f293-4b78-bd41-47e398289a69" ;
                                                          in visit.lib { bool = bool ; null = null ; undefined = undefined ; } make-directory ;
                                                      permission =
                                                        let
                                                          int = track : builtins.substring 1 4 ( builtins.toString ( 90000 + track.reduced ) ) ;
                                                          null = track : "0400" ;
                                                          string = track : track.reduced ;
                                                          in visit.lib { int = int ; null = null ; string = string ; } permission ;
                                                      salt =
                                                        let
                                                          int = track : "$(( ${ bash-variable.lib 1 } / ${ builtins.toString track.reduced } ))" ;
                                                          lambda = track : "$( ${ track.reduced ( _scripts global ) } ${ bash-variable.lib 1 } )" ;
                                                          null = track : "$(( ${ bash-variable.lib 1 } / ${ builtins.toString ( 60 * 60 ) } ))" ;
                                                          undefined = track : track.throw "48f9a455-aefa-4c8f-89ad-84ac93d0b3bd" ;
                                                          in visit.lib { int = int ; lambda = lambda ; null = null ; undefined = undefined ; } salt ;
                                                    } ;
                                                  script =
                                                    let
                                                      marked =
                                                        let
                                                          set = track : track.reduced ;
                                                          string =
                                                            track :
                                                              ''
                                                                # ${ track.qualified-name }

                                                                ${ track.reduced }
                                                              '' ;
                                                          in visit.lib { set = set ; string = string ; undefined = undefined ; } scripts ;
                                                      scripts =
                                                        {
                                                          persist =
                                                            {
                                                              cat =
                                                                ''
                                                                  export ${ global.variables.salt }=$( ${ pkgs.coreutils }/bin/echo ${ pre-salt } ${ reduced.salt } | ${ pkgs.coreutils }/bin/md5sum | ${ pkgs.coreutils }/bin/cut --bytes -32 ) &&
                                                                  if [ ! -d ${ structure-directory }/resource/${ bash-variable.lib  global.variables.salt } ]
                                                                  then
                                                                    ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }
                                                                  fi &&
                                                                  exec 201<>${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/lock &&
                                                                  ${ pkgs.flock }/bin/flock 201 &&
                                                                  if [ ! -f ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource ]
                                                                  then
                                                                    ${ reduced.init } > ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource &&
                                                                    ${ pkgs.coreutils }/bin/chmod ${ reduced.permission } ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource 
                                                                  fi &&
                                                                  ${ pkgs.coreutils }/bin/echo ${ bash-variable.lib 2 } > $( ${ pkgs.coreutils }/bin/mktemp --suffix ".pid" ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/XXXXXXXX ) &&
                                                                  if [ ! -z "${ bash-variable.lib 3 }" ]
                                                                  then
                                                                    ${ pkgs.coreutils }/bin/echo ${ bash-variable.lib 3 } > $( ${ pkgs.coreutils }/bin/mktemp --suffix ".salt" ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/XXXXXXXX )
                                                                  fi &&
                                                                  ${ pkgs.coreutils }/bin/cat ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource
                                                                '' ;
                                                              echo =
                                                                ''
                                                                  export ${ global.variables.salt }=$( ${ pkgs.coreutils }/bin/echo ${ pre-salt } ${ saltables.salt } | ${ pkgs.coreutils }/bin/md5sum | ${ pkgs.coreutils }/bin/cut --bytes -32 ) &&
                                                                  if [ ! -d ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt } ]
                                                                  then
                                                                    ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }
                                                                  fi &&
                                                                  exec 201<>${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/lock &&
                                                                  ${ pkgs.flock }/bin/flock 201 &&
                                                                  if [ ! -f ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource ]
                                                                  then
                                                                    ${ reduced.init } > ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource &&
                                                                    ${ pkgs.coreutils }/bin/chmod ${ reduced.permission } ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource 
                                                                  fi &&
                                                                  ${ pkgs.coreutils }/bin/echo ${ bash-variable.lib 2 } > $( ${ pkgs.coreutils }/bin/mktemp --suffix ".pid" ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/XXXXXXXX ) &&
                                                                  ${ pkgs.coreutils }/bin/echo ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource
                                                                '' ;
                                                            } ;
                                                          unpersist =
                                                            {
                                                              cat =
                                                                ''
                                                                  export ${ global.variables.salt }=$( ${ pkgs.coreutils }/bin/echo ${ pre-salt } ${ saltables.salt } | ${ pkgs.coreutils }/bin/md5sum | ${ pkgs.coreutils }/bin/cut --bytes -32 ) &&
                                                                  if [ ! -d ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt } ]
                                                                  then
                                                                    ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }
                                                                  fi &&
                                                                  exec 201<>${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/lock &&
                                                                  ${ pkgs.flock }/bin/flock 201 &&
                                                                  if [ ! -f ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource ]
                                                                  then
                                                                    ${ reduced.init } > ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource &&
                                                                    ${ pkgs.coreutils }/bin/chmod ${ reduced.permission } ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource 
                                                                  fi &&
                                                                  ${ pkgs.coreutils }/bin/echo ${ bash-variable.lib 2 } > $( ${ pkgs.coreutils }/bin/mktemp --suffix ".pid" ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/XXXXXXXX ) &&
                                                                  ${ pkgs.coreutils }/bin/cat ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource
                                                                '' ;
                                                              echo =
                                                                ''
                                                                  export ${ global.variables.salt }=$( ${ pkgs.coreutils }/bin/echo ${ pre-salt } ${ saltables.salt } | ${ pkgs.coreutils }/bin/md5sum | ${ pkgs.coreutils }/bin/cut --bytes -32 ) &&
                                                                  if [ ! -d ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt } ]
                                                                  then
                                                                    ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }
                                                                  fi &&
                                                                  exec 201<>${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/lock &&
                                                                  ${ pkgs.flock }/bin/flock 201 &&
                                                                  if [ ! -f ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource ]
                                                                  then
                                                                    ${ reduced.init } > ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource &&
                                                                    ${ pkgs.coreutils }/bin/chmod ${ reduced.permission } ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource 
                                                                  fi &&
                                                                  ${ pkgs.coreutils }/bin/echo ${ bash-variable.lib 2 } > $( ${ pkgs.coreutils }/bin/mktemp --suffix ".pid" ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/XXXXXXXX ) &&
                                                                  ${ pkgs.coreutils }/bin/echo ${ structure-directory }/resource/${ bash-variable.lib global.variables.salt }/resource
                                                                '' ;
                                                            } ;
                                                        } ;
                                                      in builtins.getAttr reduced.show ( builtins.getAttr reduced.persist marked ) ;
                                                  unsaltables =
                                                    {
                                                      name =
                                                        let
                                                          null = track : "resource" ;
                                                          string = track : track.reduced ;
                                                          undefined = track : track.throw "6ce60b00-c9f4-476b-a911-39ec32bbb194" ;
                                                          in visit.lib { null = null ; string = string ; undefined = undefined ; } name ;
                                                      persist =
                                                        let
                                                          bool = track : if track.reduced then "persist" else "unpersist" ;
                                                          null = track : "persist" ;
                                                          undefined = track : track.throw "4c966b48-cae2-4215-a4be-59f0ed556223" ;
                                                          in visit.lib { bool = bool ; null = null ; undefined = undefined ; } persist ;
                                                      salted =
                                                        let
                                                          bool = track : track.reduced ;
                                                          null = track : true ;
                                                          undefined = track : builtins.throw "482251d5-f6a0-47e4-8b55-cc9e42ca114e" ;
                                                          in visit.lib { bool = bool ; null = null ; undefined = undefined ; } salted ;
                                                      show =
                                                        let
                                                          bool = track : if track.reduced then "cat" else "echo" ;
                                                          null = track : "echo" ;
                                                          undefined = track : track.throw "f88b44a2-52ca-47f5-a619-540f5840dde3" ;
                                                          in visit.lib { bool = bool ; null = null ; undefined = undefined ; } show ;
                                                    } ;
                                                  in fun ( builtins.toString program ) ;
                                          in track.reduced resource ;
                                      list = track : track.reduced ;
                                      set = track : track.reduced ;
                                      undefined = track : track.throw "ee349946-85ea-43c4-9313-8c31d785de42" ;
                                      in visit.lib { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } resources ;
                                _scripts =
                                  global :
                                    let
                                      lambda =
                                        track :
                                          let
					    local =
					      unique
					        {
					          numbers =
						    {
  					              structure-directory = functions.number ;
						      temporary-directory = functions.number ;
						      temporary-dir = functions.number ;
						      log-directory = functions.number ;
						      log-dir = functions.number ;
						      resource-directory = functions.number ;
					            } ;
						  variables =
						    {
                                                      temporary-dir = functions.hash  "LOCAL" ;
                                                      log-dir = functions.hash "LOCAL" ;
                                                      resource-dir = functions.hash "LOCAL" ;
                                                      timestamp = functions.hash "LOCAL" ;
						    } ;
						}
						( structure )
						(
						  token : structure :
						    let
						      string = track.reduced structure { } ;
						      in builtins.replaceStrings [ token ] [ "" ] string == string
						) ;
					    numbers = global.numbers // local.numbers ;
                                            structure =
					      local :
					        let
						  numbers = global.numbers // local.numbers ;
						  variables = global.variables // local.variables ;
						  in
                                                {
                                                  bash-variable = bash-variable.lib ;
                                                  command = lambda : lambda ( _scripts global ) { } ;
                                                  dev = dev ;
                                                  index = builtins.toString track.index ;
                                                  log =
                                                    target :
                                                      let
                                                        string =
                                                          ''
                                                            >( ${ pkgs.moreutils }/bin/pee "${ ts }" "${ tee }" )
                                                          '' ;
                                                        tee = "( ${ pkgs.coreutils }/bin/tee > ${ dev.stdout } ) > ${ dev.null }" ;
                                                        ts = "${ pkgs.moreutils }/bin/ts > ${ bash-variable.lib variables.log-dir }/${ builtins.hashString "sha512" ( builtins.toString target ) } 2> ${ dev.null }" ;
                                                        in strip.lib ( string ) ;
                                                  log-dir = bash-variable.lib variables.log-dir ;
                                                  path =
                                                    let
                                                      int = track : "[ ${ builtins.toString track.reduced } ]" ;
                                                      list = track : builtins.concatStringsSep " - " track.reduced ;
                                                      string = track : "{ ${ track.reduced } }" ;
                                                      undefined = track : track.throw "4096a2fd-325e-473e-b987-976f5192e82b" ;
                                                      in visit.lib { int = int ; list = list ; string = string ; undefined = undefined ; } track.path ;
                                                  pkgs = pkgs ;
                                                  resource =
                                                  lambda :
                                                    let
                                                      arguments =
                                                        ''
                                                          ${ bash-variable.lib variables.timestamp } ${ bash-variable.lib "$" } ${ bash-variable.lib global.variables.salt }
                                                        '' ;
                                                      in lambda ( _resources ( resource : "$( ${ resource } ${ strip.lib arguments } )" ) ) ;
                                                structure-directory = structure-directory ;
                                                temporary-dir = bash-variable.lib variables.temporary-dir ;
                                                timestamp = bash-variable.lib variables.timestamp ;
                                              } ;
                                            script = strip.lib ( track.reduced ( structure local ) ) ;
                                            program =
                                              {
                                                pathed ? true ,
                                                simple-name ? null ,
                                                recurse ? false
                                              } :
                                                let
                                                  elem =
                                                    let
                                                      elems =
                                                        {
                                                          no-resource =
                                                            {
                                                              no-log =
                                                                {
                                                                  no-temporary =
                                                                    ''
                                                                      # ${ builtins.toString track.index }
                                                                      # ${ track.qualified-name }
                                                        
                                                                      exec ${ pkgs.writeShellScript track.simple-name script }
                                                                   '' ;
                                                                   yes-temporary =
                                                                    ''
                                                                      # ${ builtins.toString track.index }
                                                                      # ${ track.qualified-name }

                                                                      if [ ! -d ${ structure-directory } ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                                      fi &&
                                                                      exec ${ numbers.structure-directory }<>${ structure-directory }/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory } &&
                                                                      if [ ! -d ${ structure-directory }/temporary ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                                                      fi &&
                                                                      exec ${ numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.temporary-directory } &&
                                                                      export ${ variables.temporary-dir }=$( ${ pkgs.coreutils }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                                                      exec ${ numbers.temporary-directory }<>${ bash-variable.lib variables.temporary-dir }/lock &&
                                                                      ${ pkgs.flock }/bin/flock ${ numbers.temporary-directory } &&

                                                                      exec ${ pkgs.writeShellScript track.simple-name script }
                                                                   '' ;
                                                                } ;
                                                              yes-log =
                                                                {
                                                                  no-temporary =
                                                                    ''
                                                                      # ${ builtins.toString track.index }
                                                                      # ${ track.qualified-name }
                                                        
                                                                      if [ ! -d ${ structure-directory } ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                                      fi &&
                                                                      exec ${ numbers.structure-directory }<>${ structure-directory }/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory } &&
                                                                      if [ ! -d ${ structure-directory }/log ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/log
                                                                      fi &&
                                                                      exec ${ numbers.log-directory }<>${ structure-directory }/log/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.log-directory } &&
                                                                      export ${ variables.log-dir }=$( ${ pkgs.coreutils }/bin/mktemp --directory ${ structure-directory }/log/XXXXXXXX ) &&

                                                                      exec ${ pkgs.writeShellScript track.simple-name script }
                                                                    '' ;
                                                                  yes-temporary =
                                                                    ''
                                                                      # ${ builtins.toString track.index }
                                                                      # ${ track.qualified-name }
    
                                                                      if [ ! -d ${ structure-directory } ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                                      fi &&
                                                                      exec ${ numbers.structure-directory }<>${ structure-directory }/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory } &&
                                                                      if [ ! -d ${ structure-directory }/temporary ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                                                      fi &&
                                                                      exec ${ numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.temporary-directory } &&
                                                                      export ${ variables.temporary-dir }=$( ${ pkgs.coreutils }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                                                      exec ${ numbers.temporary-directory }<>${ bash-variable.lib variables.temporary-dir }/lock &&
                                                                      ${ pkgs.flock }/bin/flock ${ numbers.temporary-directory } &&
                                                                      if [ ! -d ${ structure-directory }/log ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/log
                                                                      fi &&
                                                                      exec ${ numbers.log-directory }<>${ structure-directory }/log/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.log-directory } &&
                                                                      export ${ variables.log-dir }=$( ${ pkgs.coreutils }/bin/mktemp --directory ${ structure-directory }/log/XXXXXXXX ) &&

                                                                      exec ${ pkgs.writeShellScript track.simple-name script }
                                                                   '' ;
                                                                 } ;
                                                            } ;   
                                                          yes-resource =
                                                            {
                                                              no-log =
                                                                {
                                                                  no-temporary =
                                                                    ''
                                                                      # ${ builtins.toString track.index }
                                                                      # ${ track.qualified-name }

                                                                      if [ ! -d ${ structure-directory } ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                                      fi &&
                                                                      exec ${ numbers.structure-directory }<>${ structure-directory }/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory } &&
                                                                      if [ ! -d ${ structure-directory }/resource ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resource
                                                                      fi &&
                                                                      exec ${ numbers.resource-directory }<>${ structure-directory }/resource/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.resource-directory } &&
                                                                      export ${ variables.timestamp }=$( ${ pkgs.coreutils }/bin/date +%s ) &&

                                                                      exec ${ pkgs.writeShellScript track.simple-name script }
                                                                   '' ;
                                                                  yes-temporary =
                                                                    ''
                                                                      # ${ builtins.toString track.index }
                                                                      # ${ track.qualified-name }
 
                                                                      if [ ! -d ${ structure-directory } ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                                      fi &&
                                                                      exec ${ numbers.structure-directory }<>${ structure-directory }/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory } &&
                                                                      if [ ! -d ${ structure-directory }/temporary ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                                                      fi &&
                                                                      exec ${ numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.temporary-directory } &&
                                                                      export ${ variables.temporary-dir }=$( ${ pkgs.coreutils }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                                                      exec ${ numbers.temporary-directory }<>${ bash-variable.lib variables.temporary-dir }/lock &&
                                                                      ${ pkgs.flock }/bin/flock ${ numbers.temporary-directory } &&
                                                                      if [ ! -d ${ structure-directory }/resource ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resource
                                                                      fi &&
                                                                      exec ${ numbers.resource-directory }<>${ structure-directory }/resource/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.resource-directory } &&
                                                                      export ${ variables.timestamp }=$( ${ pkgs.coreutils }/bin/date +%s ) &&
 
                                                                      exec ${ pkgs.writeShellScript track.simple-name script }
                                                                   '' ;
                                                                } ;
                                                              yes-log =
                                                                {
                                                                  no-temporary =
                                                                    ''
                                                                      # ${ builtins.toString track.index }
                                                                      # ${ track.qualified-name }
                                                          
                                                                      if [ ! -d ${ structure-directory } ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                                      fi &&
                                                                      exec ${ numbers.structure-directory }<>${ structure-directory }/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory } &&
                                                                      if [ ! -d ${ structure-directory }/log ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/log
                                                                      fi &&
                                                                      exec ${ numbers.log-directory }<>${ structure-directory }/log/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.log-directory } &&
                                                                      export ${ variables.log-dir }=$( ${ pkgs.coreutils }/bin/mktemp --directory ${ structure-directory }/log/XXXXXXXX ) &&
                                                                      if [ ! -d ${ structure-directory }/resource ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resource
                                                                      fi &&
                                                                      exec ${ numbers.resource-directory }<>${ structure-directory }/resource/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.resource-directory } &&
                                                                      export ${ variables.timestamp }=$( ${ pkgs.coreutils }/bin/date +%s ) &&

                                                                      exec ${ pkgs.writeShellScript track.simple-name script }
                                                                   '' ;
                                                                 yes-temporary =
                                                                   ''
                                                                      # FIND ME
                                                                      
                                                                      # ${ builtins.toString track.index }
                                                                      # ${ track.qualified-name }

                                                                      if [ ! -d ${ structure-directory } ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }
                                                                      fi &&
                                                                      exec ${ numbers.structure-directory }<>${ structure-directory }/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.structure-directory } &&
                                                                      if [ ! -d ${ structure-directory }/temporary ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/temporary
                                                                      fi &&
                                                                      exec ${ numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.temporary-directory } &&

                                                                      # FIND THIS
                                                                      export ${ variables.temporary-dir }=$( ${ pkgs.coreutils }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
                                                                      exec ${ numbers.temporary-directory }<>${ bash-variable.lib variables.temporary-dir }/lock &&
                                                                      ${ pkgs.flock }/bin/flock ${ numbers.temporary-directory } &&
                                                                      if [ ! -d ${ structure-directory }/log ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/log
                                                                      fi &&
                                                                      exec ${ numbers.log-directory }<>${ structure-directory }/log/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.log-directory } &&
                                                                      export ${ variables.log-dir }=$( ${ pkgs.coreutils }/bin/mktemp --directory ${ structure-directory }/log/XXXXXXXX ) &&
                                                                      if [ ! -d ${ structure-directory }/resource ]
                                                                      then
                                                                        ${ pkgs.coreutils }/bin/mkdir ${ structure-directory }/resource
                                                                      fi &&
                                                                      exec ${ numbers.resource-directory }<>${ structure-directory }/resource/lock &&
                                                                      ${ pkgs.flock }/bin/flock -s ${ numbers.resource-directory } &&
                                                                      export ${ variables.timestamp }=$( ${ pkgs.coreutils }/bin/date +%s ) &&

                                                                      exec ${ pkgs.writeShellScript track.simple-name script }
                                                                   '' ;
                                                                } ;
                                                            } ;   
                                                        } ;
                                                      logging = if builtins.replaceStrings [ variables.log-dir ] [ "" ] script == script then "no-log" else "yes-log" ;
                                                      resource =
                                                        let
                                                          search =
                                                            let
                                                              list = track : builtins.concatLists track.reduced ;
                                                              set = track : builtins.concatLists ( builtins.attrValues track.reduced ) ;
                                                              string = track : [ track.reduced ] ;
                                                              undefined = track : track.throw "4b7c374e-0bb6-495c-979c-a353c66a7e17" ;
                                                              in visit.lib { list = list ; set = set ; string = string ; undefined = undefined ; } ( _resources ( resource : resource ) ) ;
                                                          in "yes-resource" ;
                                                      temporary = if builtins.replaceStrings [ variables.log-dir ] [ "" ] script == script then "no-temporary" else "yes-temporary" ;
                                                      in builtins.getAttr temporary ( builtins.getAttr logging ( builtins.getAttr resource elems ) ) ;
                                                  name = if builtins.typeOf simple-name == "string" then simple-name else track.simple-name ;
                                                  writer = if pathed then pkgs.writeShellScriptBin else pkgs.writeShellScript ;
                                                  debug =
                                                    '' ;
                                                    '' ;
                                                  in if recurse then "FIND ME ${ name } ${ debug }" else builtins.toString ( writer name ( strip.lib elem ) ) ;
				            variables = global.variables // local.variables ;
                                            in program ;
                                        list = track : track.reduced ;
                                        set = track : track.reduced ;
                                        undefined = track : track.throw "46a080f2-eed5-464a-816c-32925a099e7e" ;
                                      in visit.lib { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } scripts.lib ;
                                functions =
                                  {
                                    hash = name : seed : builtins.concatStringsSep "_" [ name "VARIABLE" ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] ;
				    number = seed : builtins.toString ( seed + 3 ) ;
                                  } ;
                                global =
                                  unique
                                    { numbers = { } ; variables = { salt = functions.hash "GLOBAL" ; } ; }
                                    ( _scripts )
                                    (
                                      token :
                                        let
                                          lambda =
                                            track :
                                              let
                                                string = track.reduced { } ;
                                                in builtins.replaceStrings [ token ] [ "" ] string == string ;
                                          list = track : builtins.all ( p : p ) track.reduced ;
                                          set = track : builtins.all ( p : p ) ( builtins.attrValues track.reduced ) ;
                                          undefined = track : track.throw "50cfefcf-ce46-43c9-87fc-f1df8525e071" ;
                                          in visit.lib { lambda = lambda ; list = list ; set = set ; undefined = undefined ; }
                                    ) ;
                                unique =
                                  arguments : factory : predicate :
                                    let
                                      empty =
                                        let
                                          lambda = track : "" ;
                                          list = track : track.reduced ;
                                          set = track : track.reduced ;
                                          undefined = track : track.throw "533f3671-4f5a-4dfb-b35e-1a68da75b205" ;
                                          in visit.lib { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } arguments ;
                                      indexed =
                                        let
                                          lambda = track : [ track.reduced ] ;
                                          list = track : builtins.concatLists track.reduced ;
                                          set = track : builtins.concatLists ( builtins.attrValues track.reduced ) ;
                                          undefined = track : track.throw "e9ac60d0-30a1-418c-b2b3-2641f5abba31" ;
                                          in visit.lib { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } arguments ;
                                      hash = seed : builtins.concatStringsSep "_" [ "VARIABLE" ( builtins.hashString "sha512" ( builtins.toString seed ) ) ] ;
                                      reducer =
                                        previous : current :
                                          try.lib
                                            (
                                              seed :
                                                let
                                                  token = current seed ;
                                                  in
                                                    {
                                                      success = builtins.all ( p : p != token ) previous && ( builtins.trace ( if builtins.typeOf ( factory empty ) == "set" && builtins.hasAttr "config" ( factory empty ) then builtins.toString ( builtins.getAttr "config" ( ( factory empty ) ) { recurse = true ; } ) else "NO" ) true ) ; # && predicate token ( factory empty ) ;
                                                      value = builtins.concatLists [ previous [ token ] ] ;
                                                    }
                                            ) ;
                                      tokenized = builtins.foldl' reducer [ ] indexed ;
                                      transformed =
                                        let
                                          lambda = track : builtins.elemAt tokenized track.index ;
                                          list = track : track.reduced ;
                                          set = track : track.reduced ;
                                          undefined = track : track.throw "3b2753f8-eb0c-44e3-b768-b08defddb044" ;
                                          in visit.lib { lambda = lambda ; list = list ; set = set ; undefined = undefined ; } arguments ;
                                      in transformed ;
                                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                                in pkgs.mkShell { buildInputs = _inputs ; shellHook = _hook ; } ;
                          }
                      ) ;
            }
          ) ;
  }