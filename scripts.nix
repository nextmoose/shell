  {
    alpha =
      { coreutils , temporary , uuid } :
        ''
          ${ coreutils }/bin/echo 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99 &&
          ${ coreutils }/bin/date > ${ temporary }/date &&
          ${ coreutils }/bin/echo HELLO ${ uuid }
        '' ;
    entry =
      { cowsay , dev } :
        ''
          # 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99
          ${ cowsay }/bin/cowsay Hello 2> ${ dev.null }
        '' ;
    structure =
      {
        script =
          {
            structure =
              {
                no =
                  { } :
                    ''
                      # STRUCTURE
                    '' ;
                yes =
                  { coreutils , file-descriptor , flock , structure-directory } :
                    ''
                      if [ ! -d ${ structure-directory } ]
                      then
                        ${ coreutils }/bin/mkdir ${ structure-directory }
                      fi &&
                      exec ${ file-descriptor }<>${ structure-directory }/lock &&
                      ${ flock }/bin/flock ${ file-descriptor }
                    '' ;
              } ;
            main =
              { script , strip , structure , track , uuid , writeShellScript } :
                ''
                  # ${ uuid }
                  # ${ builtins.toString track.index }
                  # ${ builtins.toString track.qualified-name }

                  ${ strip structure } &&

                  exec ${ writeShellScript track.simple-name ( strip script ) }
                '' ;
              } ;
          } ;
  }