  {
    alpha =
      { coreutils , log , temporary , resources , uuid } :
        ''
          ${ coreutils }/bin/echo 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99 &&
          ${ coreutils }/bin/date > ${ temporary }/date &&
          ${ coreutils }/bin/date > ${ log "test" } &&
          ${ coreutils }/bin/echo uuid=${ uuid } &&
          ${ coreutils }/bin/echo OUTPUT BASED RESOURCE ${ resources.name } &&
          ${ coreutils }/bin/echo FILE BASED RESOURCE ${ resources.identity } &&
          ${ coreutils }/bin/echo HELLO $( ${ coreutils }/bin/tee )
        '' ;
    entry =
      { shell-scripts , cowsay , dev } :
        ''
          # 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99
          ${ cowsay }/bin/cowsay Hello 2> ${ dev.null }
        '' ;
    name =
      { git } :
        ''
          ${ git }/bin/git config user.name
        '' ;
    ssh =
      {
        identity =
          { bash-variable , coreutils , log , resources , openssh , temporary } :
            ''
              ${ openssh }/bin/ssh-keygen -f ${ temporary }/id-rsa -P "" -C "" > ${ log "ssh-keygen" } &&
              ${ coreutils }/bin/cat ${ temporary }/id-rsa > ${ bash-variable 1 } &&
              ${ coreutils }/bin/chmod 0400 ${ bash-variable 1 }
            '' ;
      } ;
    touch =
      { bash-variable , coreutils } :
        ''
          ${ coreutils }/bin/touch ${ bash-variable 2 }
        '' ;
    structure =
      {
        release =
          {
            log =
              {
                directory =
                  { bash-variable , coreutils , findutils , flock , gnused , local , shell-scripts , structure-directory } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE LOG >> ${ bash-variable 2 } &&
                      if [ -d ${ structure-directory }/log ]
                      then
                        exec ${ local.numbers.log-directory }<>${ structure-directory }/log/lock &&
			${ flock }/bin/flock -s ${ local.numbers.log-directory } &&
                        ${ coreutils }/bin/echo BEGIN LOCK RELEASE LOG >> ${ bash-variable 2 } &&
                        ${ findutils }/bin/find ${ structure-directory }/log -mindepth 1 -maxdepth 1 -type d -name "????????" -exec ${ shell-scripts.structure.release.log.dir } {} ${ bash-variable 1 } ${ bash-variable 2 } \;
                        fi &&
                      ${ coreutils }/bin/echo END RELEASE LOG >> ${ bash-variable 2 }
                    '' ;
                dir =
                 { bash-variable , coreutils , findutils , flock , local , shell-scripts } :
                   ''
                     ${ coreutils }/bin/echo BEGIN RELEASE LOG ${ bash-variable 1 } >> ${ bash-variable 3 } &&
                     exec ${ local.numbers.log-dir }<>${ bash-variable 1 }/lock &&
                     ${ flock }/bin/flock -n ${ local.numbers.log-dir } &&
                     ${ coreutils }/bin/echo BEGIN LOCK RELEASE LOG ${ bash-variable 1 } >> ${ bash-variable 3 } &&
                     ${ findutils }/bin/find ${ bash-variable 1 } -mindepth 1 -maxdepth 1 -name "*.*" -type f -exec ${ shell-scripts.structure.release.log.file } {} ${ bash-variable 2 } ${ bash-variable 3 } \; &&
                     ${ coreutils }/bin/rm --recursive --force ${ bash-variable 1 } &&
                     ${ coreutils }/bin/echo END RELEASE LOG ${ bash-variable 1 } >> ${ bash-variable 3 }
                   '' ;
                 file =
                   { bash-variable , coreutils , gnused } :
                     ''
                       ${ coreutils }/bin/echo BEGIN RELEASE FILE ${ bash-variable 1 } >> ${ bash-variable 3 } &&
                       EXTENSION=${ bash-variable "1##*." } &&
                       ${ coreutils }/bin/echo "${ bash-variable "EXTENSION" }:" >> ${ bash-variable 2 } &&
                       ${ gnused }/bin/sed -e 's#^\([0-9]*.[0-9]*\) \(.*\)$#  -\n    timestamp: \1\n    value: >\n      \2#' ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                       ${ coreutils }/bin/rm ${ bash-variable 1 } &&
                       ${ coreutils }/bin/echo END RELEASE FILE ${ bash-variable 1 } >> ${ bash-variable 3 }
                     '' ;
              } ;
            temporary =
              {
                directory =
                  { bash-variable , coreutils , findutils , flock , local , shell-scripts , structure-directory } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE TEMPORARY >> ${ bash-variable 1 } &&
                      if [ -d ${ structure-directory }/temporary ]
                      then
                        exec ${ local.numbers.temporary-directory }<>${ structure-directory }/temporary/lock &&
                        ${ flock }/bin/flock -s ${ local.numbers.temporary-directory } &&
                        ${ coreutils }/bin/echo BEGIN LOCK RELEASE TEMPORARY >> ${ bash-variable 1 } &&
                        ${ findutils }/bin/find ${ structure-directory }/temporary -mindepth 1 -maxdepth 1 -type d -exec ${ shell-scripts.structure.release.temporary.dir } {} ${ bash-variable 1 } \;
                        ${ coreutils }/bin/echo END RELEASE TEMPORARY >> ${ bash-variable 1 }
                      fi &&
                      ${ coreutils }/bin/echo END RELEASE TEMPORARY >> ${ bash-variable 1 }
                    '' ;
                dir =
                  { bash-variable , coreutils , flock , local } :
                    ''
                      ${ coreutils }/bin/echo BEGIN RELEASE TEMPORARY ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                      exec ${ local.numbers.temporary-dir }<>${ bash-variable 1 }/lock &&
                      ${ flock }/bin/flock -n ${ local.numbers.temporary-dir } &&
                      ${ coreutils }/bin/echo BEGIN LOCK RELEASE TEMPORARY ${ bash-variable 1 } >> ${ bash-variable 2 } &&
                      ${ coreutils }/bin/rm --recursive --force ${ bash-variable 1 } &&
                      ${ coreutils }/bin/echo END RELEASE TEMPORARY ${ bash-variable 1 } >> ${ bash-variable 2 }
                    '' ;
              } ;
          } ;
        _resource =
          {
            main =
              { bash-variable , structure-directory } :
                ''
                  PARENT_TIMESTAMP=${ bash-variable 1 } &&
                  PARENT_PROCESS=${ bash-variable 2 } &&
                  PARENT_SALT=${ bash-variable 3 } &&
                  HASH=$( ${ bash-variable 4 } ${ bash-variable "PARENT_TIMESTAMP" } )&&
                  INIT=${ bash-variable 5 } &&
                  SHOW=${ bash-variable 6 } &&
                  if [ ! -d ${ structure-directory }/resource/${ bash-variable "HASH" } ]
                  then
                    ${ bash-variable "INIT" }
                  fi &&
                  ${ bash-variable "SHOW" } ${ structure-directory }/structure/${ bash-variable "HASH" }
                '' ;
          } ;
      } ;
    test =
      {
        delay =
          { coreutils } :
            ''
              ${ coreutils }/bin/sleep 10s &&
              ${ coreutils }/bin/2800dd15-d6c8-495e-94c1-bc0adb1118d7
            '' ;
        create-log-file =
          { bash-variable , coreutils , log } :
            ''
              ${ coreutils }/bin/echo ${ bash-variable 1 } > ${ log "a450f15b-9891-441c-b066-29a21a245d39" }
            '' ;
        create-temporary-file =
          { bash-variable , coreutils , temporary } :
            ''
              ${ coreutils }/bin/echo ${ bash-variable 2 } > ${ temporary }/${ bash-variable 1 }
            '' ;
        entry =
          { cowsay , dev } :
            ''
              ${ cowsay }/bin/cowsay TESTING 2> ${ dev.null }
            '' ;
        file =
          { bash-variable , coreutils } :
            ''
              ${ coreutils }/bin/echo 7eaa6251-82e0-47c7-b492-7ababc3e709b > ${ bash-variable 1 }
            '' ;
        output =
          { coreutils } :
            ''
              ${ coreutils }/bin/echo 2f7c0f5b-80f9-4b32-870a-3868702f0c18
            '' ;
        testing-log =
          { bash-variable , coreutils , findutils , flock , gnused , local , resources , shell-scripts , structure-directory , temporary , yq } :
            ''
              exec ${ local.numbers.test }<>${ resources.test.lock } &&
              ${ flock }/bin/flock ${ local.numbers.test } &&
              ${ shell-scripts.structure.release.log.directory } ${ temporary }/211 ${ temporary }/212 > ${ temporary }/213 2> ${ temporary }/214 &&
              ${ coreutils }/bin/echo We do not test 211 because we do not know how it will end up &&
              if [ $( ${ coreutils }/bin/wc --lines ${ temporary }/212 | ${ coreutils }/bin/cut --delimiter " " --field 1 ) -lt 2 ]
              then
                ${ coreutils }/bin/echo We were expecting two or more lines of output &&
                exit 64
              else
                ${ coreutils }/bin/echo Regardless of initial conditions we expect at least two lines of output.
              fi &&
              if [ -s ${ temporary }/213 ]
              then
                ${ coreutils }/bin/echo release outputed &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any output
              fi &&
              if [ -s ${ temporary }/214 ]
              then
                ${ coreutils }/bin/echo release errored &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any error
              fi &&
              ${ shell-scripts.test.create-log-file } 310aaf17-13f2-4919-9edb-60d3bc3af35b &&
	      ${ coreutils }/bin/sleep 10s &&
              LOGGED=$( ${ findutils }/bin/find ${ structure-directory }/log -mindepth 1 -maxdepth 1 -type d ) &&
              ${ coreutils }/bin/echo We have the following LOG DIRECTORIES ${ bash-variable "LOGGED" } &&
              ${ shell-scripts.structure.release.log.directory } ${ temporary }/221 ${ temporary }/222 > ${ temporary }/223 2> ${ temporary }/224 &&
              OBSERVED=$( ${ coreutils }/bin/cat ${ temporary }/221 | ${ yq }/bin/yq --raw-output '.${ builtins.hashString "sha512" "a450f15b-9891-441c-b066-29a21a245d39" }[ 0 ].value' ) &&
              if [ "310aaf17-13f2-4919-9edb-60d3bc3af35b" != ${ bash-variable "OBSERVED" } ]
              then
                ${ coreutils }/bin/echo We did not observed the expected value &&
                exit 64
              else
                ${ coreutils }/bin/echo OBSERVED is as EXPECTED
              fi &&
              for LOG in ${ bash-variable "LOGGED" }
              do
                if [ -d ${ bash-variable "LOG" } ]
                then
                  ${ coreutils }/bin/echo We were expecting ${ bash-variable "LOG" } to be released &&
                  exit 64
                else
                  ${ coreutils }/bin/echo Thankfully ${ bash-variable "LOG" } has been release
                fi
              done &&
              if [ $( ${ coreutils }/bin/wc --lines ${ temporary }/222 | ${ coreutils }/bin/cut --delimiter " " --field 1 ) -lt 8 ]
              then
                ${ coreutils }/bin/echo We were expecting two or more lines of output &&
                exit 64
              else
                ${ coreutils }/bin/echo Regardless of initial conditions we created at least one log record so we expect at least eight lines of output
              fi &&
              if [ -s ${ temporary }/223 ]
              then
                ${ coreutils }/bin/echo release outputed &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any output
              fi &&
              if [ -s ${ temporary }/224 ]
              then
                ${ coreutils }/bin/echo release errored &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any error
              fi &&
              ${ coreutils }/bin/echo The log functionality appears to work
            '' ;
        testing-resource =
          { coreutils , hashes} :
            ''
              PARENT_TIMESTAMP=$( ${ coreutils }/bin/date +%s ) &&
              ${ coreutils }/bin/echo '${ hashes }' &&
              ${ coreutils }/bin/echo &&
              ${ coreutils }/bin/echo ${ hashes }
            '' ;
        testing-temporary =
          { bash-variable , coreutils , dev , findutils , flock , local , resources , shell-scripts , structure-directory , temporary } :
            ''
              exec ${ local.numbers.test }<>${ resources.test.lock } &&
              ${ flock }/bin/flock ${ local.numbers.test } &&
              ${ shell-scripts.structure.release.temporary.directory } ${ temporary }/111 > ${ temporary }/112 2> ${ temporary }/113 &&
              if [ $( ${ coreutils }/bin/wc --lines ${ temporary }/111 | ${ coreutils }/bin/cut --delimiter " " --field 1 ) -lt 2 ]
              then
                ${ coreutils }/bin/echo We were expecting the release output to be at least two lines long &&
                exit 64
              else
                ${ coreutils }/bin/echo The release output was at least two lines long
              fi &&
              if [ -s ${ temporary }/112 ]
              then
                ${ coreutils }/bin/echo release outputed &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any output
              fi &&
              if [ -s ${ temporary }/113 ]
              then
                ${ coreutils }/bin/echo release errored &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any error
              fi &&
              ${ shell-scripts.test.create-temporary-file } 13ae4498-57cb-4beb-aa19-77691bfc44af 3fbd5509-1227-48c5-9818-80f0ab91f996 &&
              TEMPED=$( ${ findutils }/bin/find ${ structure-directory }/temporary -mindepth 1 -maxdepth 1 -type d ) &&
              ${ coreutils }/bin/echo We have the following temp directories ${ bash-variable "TEMPED" } &&
              ${ shell-scripts.structure.release.temporary.directory } ${ temporary }/121 > ${ temporary }/122 2> ${ temporary }/123 &&
              for TEMP in ${ bash-variable "TEMPED" }
              do
                if [ ${ bash-variable "TEMP" }/temporary == ${ temporary } ]
                then
                  ${ coreutils }/bin/echo We do not expect ${ temporary } to be released
                elif [ -d ${ bash-variable "TEMP" } ]
                then
                  ${ coreutils }/bin/echo We were expecting ${ bash-variable "TEMP" } to be released &&
                  exit 64
                else
                  ${ coreutils }/bin/echo Thankfully ${ bash-variable "TEMP" } was released
                fi
              done &&
              if [ $( ${ coreutils }/bin/wc --lines ${ temporary }/121 | ${ coreutils }/bin/cut --delimiter " " --field 1 ) -lt 2 ]
              then
                ${ coreutils }/bin/echo We were expecting the release output to be at least two lines long &&
                exit 64
              else
                ${ coreutils }/bin/echo The release output was at least two lines long
              fi &&
              if [ -s ${ temporary }/122 ]
              then
                ${ coreutils }/bin/echo release outputed &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any output
              fi &&
              if [ -s ${ temporary }/123 ]
              then
                ${ coreutils }/bin/echo release errored &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any error
              fi &&
              ${ coreutils }/bin/echo The temporary functionality appears to work
            '' ;
        testing-temporary-2 =
          { bash-variable , coreutils , dev , findutils , flock , local , shell-scripts , structure-directory , temporary } :
            ''
              ${ shell-scripts.structure.release.temporary.directory } ${ temporary }/111 > ${ temporary }/112 2> ${ temporary }/113 &&
              if [ $( ${ coreutils }/bin/wc --lines ${ temporary }/111 | ${ coreutils }/bin/cut --delimiter " " --field 1 ) -lt 2 ]
              then
                ${ coreutils }/bin/echo We were expecting the release output to be at least two lines long &&
                exit 64
              else
                ${ coreutils }/bin/echo The release output was at least two lines long
              fi &&
              if [ -s ${ temporary }/112 ]
              then
                ${ coreutils }/bin/echo release outputed &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any output
              fi &&
              if [ -s ${ temporary }/113 ]
              then
                ${ coreutils }/bin/echo release errored &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any error
              fi &&
              ${ shell-scripts.test.create-temporary-file } 13ae4498-57cb-4beb-aa19-77691bfc44af 3fbd5509-1227-48c5-9818-80f0ab91f996 &&
              TEMPED=$( ${ findutils }/bin/find ${ structure-directory }/temporary -mindepth 1 -maxdepth 1 -type d ) &&
              ${ coreutils }/bin/echo We have the following temp directories ${ bash-variable "TEMPED" } &&
              ${ shell-scripts.structure.release.temporary.directory } ${ temporary }/121 > ${ temporary }/122 2> ${ temporary }/123 &&
              for TEMP in ${ bash-variable "TEMPED" }
              do
                if [ ${ bash-variable "TEMP" }/temporary == ${ temporary } ]
                then
                  ${ coreutils }/bin/echo We do not expect ${ temporary } to be released
                elif [ -d ${ bash-variable "TEMP" } ]
                then
                  ${ coreutils }/bin/echo We were expecting ${ bash-variable "TEMP" } to be released &&
                  exit 64
                else
                  ${ coreutils }/bin/echo Thankfully ${ bash-variable "TEMP" } was released
                fi
              done &&
              if [ $( ${ coreutils }/bin/wc --lines ${ temporary }/121 | ${ coreutils }/bin/cut --delimiter " " --field 1 ) -lt 2 ]
              then
                ${ coreutils }/bin/echo We were expecting the release output to be at least two lines long &&
                exit 64
              else
                ${ coreutils }/bin/echo The release output was at least two lines long
              fi &&
              if [ -s ${ temporary }/122 ]
              then
                ${ coreutils }/bin/echo release outputed &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any output
              fi &&
              if [ -s ${ temporary }/123 ]
              then
                ${ coreutils }/bin/echo release errored &&
                exit 64
              else
                ${ coreutils }/bin/echo We never expect any error
              fi &&
              ${ coreutils }/bin/echo The temporary functionality appears to work
            '' ;
      } ;
  }