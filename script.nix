{
  build ,
  err ,
  fun ,
  host ,
  lambda ,
  null ,
  out ,
  private ,
  scripts ,
  structure-directory ,
  target ,
  track
} @ arguments :
  let
    bash-variable = builtins.import ./bash-variable.nix ;
    inject = builtins.import ./inject.nix ;
    program =
      ''
        ${ script }
      '' ;
    script = inject lambda ( arguments // { bash-variable = bash-variable ; resource = inject resource arguments ; private = private ; } ) ;
    resource = import ./resource.nix ;
    shell-script = target.writeShellScript simple-name program ;
    shell-script-bin = target.writeShellScriptBin simple-name program ;
    simple-name =
      if builtins.length track.path == 0 then builtins.throw "eb08324d-2f45-437a-93a1-1ff7694caa4f"
      else if builtins.typeOf ( builtins.elemAt track.path ( builtins.length track.path - 1 ) ) != "string" then builtins.throw "199234b8-fcfd-477f-a71a-6a303201deeb"
      else builtins.elemAt track.path ( builtins.length track.path - 1 ) ;
    in
      inject fun { script = script ; shell-script = shell-script ; shell-script-bin = shell-script-bin ; }