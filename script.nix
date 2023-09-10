{
  build ,
  err ,
  hash ,
  host ,
  null ,
  out ,
  private ,
  process ,
  scripts ,
  shared ,
  structure-directory ,
  target ,
  variables
} @ arguments : fun : track :
  let
    bash-variable = builtins.import ./bash-variable.nix ;
    code =
      let
        isolated = { init ? builtins.null , release ? builtins.null } : resource arguments { init = init ; release = release ; salt = builtins.null ; track = builtins.null ; } ;
        penultimate =
          {
            isolated = isolated ;
            shell-script = shell-script ;
            shell-script-bin = shell-script-bin ;

	    expressions = builtins.mapAttrs ( name : value : bash-variable value ) variables ;
            
            hash = bash-variable hash ;
            process = bash-variable process ;
            timestamp = bash-variable arguments.timestamp ;

            shared = shared ;

	    util =
	      {
	        bash-variable = bash-variable ;
	      } ;
          } ;
        shared =
          let
            lambda = track : track.input ( { init ? builtins.null , release ? builtins.null , salt ? builtins.null } : resource arguments { init = init ; release = release ; salt = salt ; track = track ; } ) ;
            list = track : track.interim ;
            null = track : null ;
            set = track : track.interim ;
            undefined = track : track.throw "3318b42b-515d-4b9f-b210-096ea97e928c" ;
            in visit { lambda = lambda ; list = list ; null = null ; set = set ; undefined = undefined ; } arguments.shared ;
        shell-script-bin = scripts : scripts shell-script-bins ;
        shell-script-bins = inject scripts arguments ( { shell-script-bin } : shell-script-bin ) ;
        shell-script = scripts : scripts shell-scripts ;
        shell-scripts = inject scripts arguments ( { shell-script } : shell-script ) ;
        ultimate = arguments // penultimate ;
        in inject lambda ultimate ;
    inject = builtins.import ./inject.nix ;
    lambda =
      let
        lambda = track : track.input ;
        string = track : { } : track.input ;
        undefined = track : track.throw "a1b9448a-a542-4183-9862-59cd1c658341" ;
        in visit { lambda = lambda ; string = string ; undefined = undefined ; } track.input ;
    program =
      ''
        ${ strip timestamp }
        
        ${ code }
      '' ;
    resource = builtins.import ./resource.nix ;
    scripts = builtins.import ./scripts.nix ;
    shell-script = target.writeShellScript ( simple-name "script" ) program ;
    shell-script-bin = target.writeShellScriptBin ( simple-name ( builtins.throw "199234b8-fcfd-477f-a71a-6a303201deeb" ) ) program ;
    simple-name =
      default :
        if builtins.length track.path == 0 then builtins.throw "eb08324d-2f45-437a-93a1-1ff7694caa4f"
        else if builtins.typeOf ( builtins.elemAt track.path ( builtins.length track.path - 1 ) ) != "string" then default
        else builtins.elemAt track.path ( builtins.length track.path - 1 ) ;
    strip = builtins.import ./strip.nix ;
    timestamp =
      let
        null = track : "# UNDEFINED TIMESTAMP" ;
        string =
          track :
            ''
              export ${ variables.timestamp }=${ bash-variable "${ variables.timestamp }:=$( ${ target.coreutils }/bin/date +%s ) &&" }
            '' ;
        undefined = track : track.throw "491ed2c7-73ed-4fe6-bee8-f6462cc0f0ca" ;
        in visit { null = null ; string = string ; undefined = undefined ; } variables.timestamp ;
    try = builtins.import ./try.nix ;
    visit = builtins.import ./visit.nix ;
    in
      inject fun { code = code ; shell-script = shell-script ; shell-script-bin = shell-script-bin ; }