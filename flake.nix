  {
    inputs =
      {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        systems.url = "github:nix-systems/default";
      } ;
    outputs = { self , nixpkgs , systems } :
      let
        eachSystem = nixpkgs.lib.genAttrs ( import systems ) ;
	in
          {
	    flakeModule = ./flake-module.nix ;
          } ;
}