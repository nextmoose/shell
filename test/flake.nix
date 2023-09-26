  {
    inputs =
      {
        flake-utils.url = "github:numtide/flake-utils?rev=919d646de7be200f3bf08cb76ae1f09402b6f9b4" ;
        nixpkgs.url = "github:NixOs/nixpkgs?rev=7cdce123f56f970e3de40f24f6ec4fafe7cd52b4" ;
        shell.url = "/home/runner/work/shell/shell" ;
      } ;
    outputs =
      { flake-utils , nixpkgs , shell , self } :
        let
          fun =
            system :
              let
                arguments =
                  {
                    build = pkgs ;
                    host = pkgs ;
                    private = "82b71638-804f-4533-b6dc-2f87b7ae5afc" ;
                    scripts =
          	      {
		        entrypoint =
			  { shell-scripts , target } :
			    ''
			      ${ target.cowsay }/bin/cowsay Hello &&
			        ${ target.coreutils }/bin/echo ${ shell-scripts ( scripts : scripts.handlers.red ) } &&
			        ${ target.coreutils }/bin/cat ${ shell-scripts ( scripts : scripts.handlers.red ) }
			    '' ;
		        handlers =
			  let
			    arguments = [ [ "red" "green" "blue" ] ] ;
			    lambda =
			      index : color : { target } :
			        ''
				  ${ target.coreutils }/bin/echo ${ color } ${ builtins.toString index } > ${ bash-variable path
				  } &&
				    ${ target.coreutils }/bin/chmod 0400 ${ bash-variable path }
				'' ;
			    in product lambda arguments ;
		      } ;
                    shared =
                      {
                      } ;
                    structure-directory = "/home/runner/resources" ;
                    target = pkgs ;
                  } ;
                fun =
                  fun :
                    let
                      hooks = fun ( { code } : code ) ;
                      inputs = fun ( { shell-script-bin } : shell-script-bin ) ;
                      path =
                        [
                        ] ;
                      in { devShell = pkgs.mkShell { shellHook = hooks.entrypoint ; buildInputs = path ; } ; } ;
                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                in shell.lib arguments fun ;
	  product =
	    let
              denulled =
                lambda :
                  let
                    list = track : track.interim ;
                    null = track : builtins.foldl' ( previous : current : previous current ) ( lambda track.index ) track.path ;
                    set = track : track.interim ;
	            undefined = track : track.throw "46098193-2176-441d-a426-22ef6b995136" ;
	            in visit { list = list ; null = null ; set = set ; undefined = undefined ; } ;
              nulled = builtins.foldl' reducer null ;
                reducer =
                  previous : current :
                    let
                      c =
                        let
                          int = track : builtins.genList ( index : null ) track.input ;
                          list = track : builtins.listToAttrs ( builtins.map ( name : { name = name ; value = null ; } ) track.input ) ;
                          undefined = track : track.throw "a0b34fff-c88d-4068-abd7-08b2a33a6f4b" ;
                          in visit { int = int ; list = list ; undefined = undefined ; } current ;
	              p =
                        let
                          list = track : track.interim ;
                          null = track : c ;
                          set = track : track.interim ;
                          undefined = track : track.throw "59fc87ec-ef19-4b71-939d-c4b652cb2cb7" ;
                          in visit { list = list ; null = null ; set = set ; undefined = undefined ; } previous ;
                      in p ;
              visit = builtins.import ./visit.nix ;
            in lambda : arguments : denulled lambda ( nulled arguments )
          in flake-utils.lib.eachDefaultSystem fun ;
  }

