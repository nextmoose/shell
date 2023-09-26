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
			  { shell-script , target } :
			    ''
			      ${ target.cowsay }/bin/cowsay Hello
			    '' ;
		        handlers =
			  let
			    arguments = [ [ "red" "green" "blue" ] ] ;
			    lambda =
			      index : color : { bash-variable , path , target } :
			        ''
				  ${ target.coreutils }/bin/echo ${ color } ${ builtins.toString index } > ${ bash-variable path }
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
	  product = import ./product.nix ;
          in flake-utils.lib.eachDefaultSystem fun ;
  }

