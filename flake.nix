  {
    inputs =
      {
 	flake-parts.url = "github:hercules-ci/flake-parts" ;
        nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843" ;
        scripts.url = "/home/emory/projects/61EJI0cs" ;
      } ;
    outputs =
      inputs @ { flake-parts , ... } :
        flake-parts.lib.mkFlake
	  { inherit inputs ; }
	  {
	    imports = [ ./foobar.nix ] ;
	    systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ] ;
	  } ;
  }