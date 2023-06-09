  { bash-variable , coreutils, flock , global , local , structure-directory }  :
    {
      log =
        {
	  no =
	    ''
	      # NO LOG
  	    '' ;
	  yes =
	    ''
              # log
              if [ ! -d ${ structure-directory }/log ]
              then
                ${ coreutils }/bin/mkdir ${ structure-directory }/log
              fi &&
              exec ${ local.numbers.log-directory }<>${ structure-directory }/log/lock &&
              ${ flock }/bin/flock -s ${ local.numbers.log-directory } &&
              ${ local.variables.log-dir }=$( ${ coreutils }/bin/mktemp --directory ${ structure-directory }/log/XXXXXXXX ) &&
              exec ${ local.numbers.log-dir }<>${ bash-variable local.variables.log-dir }/lock &&
              ${ flock }/bin/flock ${ local.numbers.log-dir }
	    '' ;
        } ;
      resource =
        {
	  no =
	    ''
	      # NO RESOURCE
	    '' ;
	  yes =
	    ''
              # resource
              if [ ! -d ${ structure-directory }/resource ]
              then
                ${ coreutils }/bin/mkdir ${ structure-directory }/resource
              fi &&
              exec ${ local.numbers.resource-directory }<>${ structure-directory }/resource/lock &&
              ${ flock }/bin/flock -s ${ local.numbers.resource-directory } &&
              export ${ global.variables.timestamp }=$( ${ coreutils }/bin/date +%s )
	    '' ;
	} ;
      structure =
        {
	  no =
	    ''
	      # NO STRUCTURE
	    '' ;
	  yes =
	    ''
              # structure
              if [ ! -d ${ structure-directory } ]
              then
                ${ coreutils }/bin/mkdir ${ structure-directory }
              fi &&
              exec ${ local.numbers.structure-directory }<>${ structure-directory }/lock &&
              ${ flock }/bin/flock -s ${ local.numbers.structure-directory }
	    '' ;
	} ;
      temporary =
        {
	  no =
	    ''
	      # NO TEMPORARY
	    '' ;
	  yes =
	    ''
              # temporary
              if [ ! -d ${ structure-directory }/temporary ]
              then
                ${ coreutils }/bin/mkdir ${ structure-directory }/temporary
              fi &&
              exec ${ local.numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
              ${ flock }/bin/flock -s ${ local.numbers.temporary-directory } &&
              ${ local.variables.temporary-dir }=$( ${ coreutils }/bin/mktemp --directory ${ structure-directory }/temporary/XXXXXXXX ) &&
              exec ${ local.numbers.temporary-dir }<>${ bash-variable local.variables.temporary-dir }/lock &&
              ${ flock }/bin/flock ${ local.numbers.temporary-dir } &&
	      ${ coreutils }/bin/mkdir ${ bash-variable local.variables.temporary-dir }/temporary
	    '' ;
	} ;
    }