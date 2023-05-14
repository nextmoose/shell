  {
    alpha =
      { coreutils , uuid } :
        ''
          # 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99
          ${ coreutils }/bin/echo HELLO ${ uuid }
        '' ;
    entry =
      { cowsay , dev } :
        ''
          # 31bca02094eb78126a517b206a88c73cfa9ec6f704c7030d18212cace820f025f00bf0ea68dbf3f3a5436ca63b53bf7bf80ad8d5de7d8359d0b7fed9dbc3ab99
          ${ cowsay }/bin/cowsay Hello 2> ${ dev.null }
        '' ;
    script =
      { script , strip , structure , track , uuid , writeShellScript } :
        ''
          # ${ uuid }
          # ${ builtins.toString track.index }
          # ${ builtins.toString track.qualified-name }

	  ${ structure } &&

          exec ${ writeShellScript track.simple-name ( strip script ) }
        '' ;
  }