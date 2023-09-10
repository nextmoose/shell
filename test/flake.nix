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
                          { target } :
                            ''
                              ${ target.cowsay }/bin/cowsay ENTRY POINT
                            '' ;
			resource =
			  let
			    script = { target , util } : "${ target.coreutils }/bin/echo hI '${ util.bash-variable "1" }'" ;
			    in
			      {
			        isolated-000 = script ;
			        isolated-100 = script ;
			        isolated-200 = script ;
			        isolated-010 = script ;
			        isolated-110 = script ;
			        isolated-210 = script ;
			        isolated-001 = script ;
			        isolated-101 = script ;
			        isolated-201 = script ;
			        isolated-011 = script ;
			        isolated-111 = script ;
			        isolated-211 = script ;
			      } ;
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
			  inputs.resource.isolated-000
			  inputs.resource.isolated-100
			  inputs.resource.isolated-200
			  inputs.resource.isolated-010
			  inputs.resource.isolated-110
			  inputs.resource.isolated-210
			  inputs.resource.isolated-001
			  inputs.resource.isolated-101
			  inputs.resource.isolated-201
			  inputs.resource.isolated-011
			  inputs.resource.isolated-111
			  inputs.resource.isolated-211
			] ;
                      in { devShell = pkgs.mkShell { shellHook = hooks.entrypoint ; buildInputs = path ; } ; } ;
                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                in shell.lib arguments fun ;
          in flake-utils.lib.eachDefaultSystem fun ;
  }

