  {
    entry =
      { cowsay , dev } :
        ''
	  ${ cowsay }/bin/cowsay Hello > ${ dev.null }
	''
  }