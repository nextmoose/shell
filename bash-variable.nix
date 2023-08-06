expression :
  let
    stringify = builtins.import ./stringify.nix ;
    in builtins.concatStringsSep "" [ "$" "{" ( stringify expression ) "}" ]