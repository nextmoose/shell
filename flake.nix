  {
      inputs =
        {
          flake-utils.url = "github:numtide/flake-utils" ;
	  utils.url = "github:nextmoose/utils" ;
        } ;
      outputs =
        { self , flake-utils , utils } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
	        lib =
		  (
		    nixpkgs : scripts : hook :
		      let
		        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;	  
			structure =
			  let
			    _utils = builtins.getAttr system utils.lib ;
			    in
			      {
			        pkgs = pkgs ;
			        scripts = _utils.visit { set = track : track.processed ; string = track : track.processed ; } ( scripts structure ) ;
			        utils = _utils ;
			      } ;
			in
		          pkgs.mkShell
			    {
			      buildInputs =
			        [
				  (
				    pkgs.writeShellScriptBin
				      "generate"
				      ''
				        while ${ builtins.concatStringsSep "" [ "$" "{" "#" "}" ] } -gt 0
					do
					  case ${ builtins.concatStringsSep "" [ "\"" "$" "{" "1" "}" "\"" ] } in
					    private-file)
					      PRIVATE_FILE=${ builtins.concatStringsSep "" [ "\"" "$" "{" "2" "}" "\"" ] } &&
					        shift 2 &&
						break
					    ;;
					    *)
					      ${ pkgs.coreutils }/bin/echo UNEXPECTED &&
					        exit 64 &&
						break
				            ;;
					  esac
					done
				      ''
				  )
				] ;
			      shellHook = hook ( structure.scripts ) ;
			    }
		  ) ;
              }
      ) ;
    }
