{
  build ,
  err ,
  hash ,
  host ,
  null ,
  out ,
  path ,
  private ,
  process ,
  scripts ,
  shared ,
  structure-directory ,
  target ,
  timestamp
} @ arguments : fun : track :
  let
    bash-variable = builtins.import ./bash-variable.nix ;
    code =
      let
        isolated = { init ? builtins.null , release ? builtins.null } : resource arguments { init = init ; release = release ; salt = builtins.null ; track = builtins.null ; } ;
	shared =
	  let
	    lambda = track : track.input ( { init ? builtins.null , release ? builtins.null , salt ? builtins.null } : resource arguments { init = init ; release = release ; salt = salt ; track = track ; } ) ;
	    list = track : track.interim ;
	    null = track : null ;
	    set = track : track.interim ;
	    undefined = track : track.throw "3318b42b-515d-4b9f-b210-096ea97e928c" ;
	    in visit { lambda = lambda ; list = list ; null = null ; set = set ; undefined = undefined ; } arguments.shared ;
	shell-script-bins = inject scripts arguments ( { shell-script-bin } : shell-script-bin ) ;
	shell-scripts = inject scripts arguments ( { shell-script } : shell-script ) ;
        ultimate = arguments // { bash-variable = bash-variable ; hash = bash-variable hash ; isolated = isolated ; private = private ; shared = shared ; shell-scripts = shell-scripts ; shell-script-bins = shell-script-bins ; timestamp = bash-variable arguments.timestamp ; } ;
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
    shell-script = target.writeShellScript simple-name program ;
    shell-script-bin = target.writeShellScriptBin simple-name program ;
    simple-name =
      if builtins.length track.path == 0 then builtins.throw "eb08324d-2f45-437a-93a1-1ff7694caa4f"
      else if builtins.typeOf ( builtins.elemAt track.path ( builtins.length track.path - 1 ) ) != "string" then builtins.throw "199234b8-fcfd-477f-a71a-6a303201deeb"
      else builtins.elemAt track.path ( builtins.length track.path - 1 ) ;
    strip = builtins.import ./strip.nix ;
    timestamp =
      let
        null = track : "# UNDEFINED TIMESTAMP" ;
	string =
	  track :
	    ''
	      export ${ arguments.timestamp }=${ bash-variable "${ arguments.timestamp }:=$( ${ target.coreutils }/bin/date +%s )" }
	    '' ;
	undefined = track : track.throw "491ed2c7-73ed-4fe6-bee8-f6462cc0f0ca" ;
        in visit { null = null ; string = string ; undefined = undefined ; } arguments.timestamp ;
    try = builtins.import ./try.nix ;
    visit = builtins.import ./visit.nix ;
    in
      inject fun { code = code ; shell-script = shell-script ; shell-script-bin = shell-script-bin ; }