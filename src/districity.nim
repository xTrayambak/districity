import std/os, argparse, chronicles, 
       project, project_install, project_update, project_create

proc help =
  echo """
districity [operation] [targets]

Flags:
  --help, -h               show this message
  --dont-install           don't install packages
  --dont-configure-user    don't configure the user
  --dont-handle-home       don't handle the home/shell configuration
  --dont-handle-dotfiles   don't handle the dotfiles
  --dont-handle-scripts    don't compile/handle scripts
  --dotfiles               just handle dotfiles
  --scripts                just compile/handle scripts

Operations:
  apply         apply a project to the system
  upgrade       upgrade a project and apply it to the system
  validate      validate a project, i.e, ensure that it can be applied to the system
  create        create a basic project
"""
  quit(0)

proc main {.inline.} =
  let 
    args = parseArguments()
    targets = args.getTargets()

  if args.isSwitchEnabled("help", "h"):
    help()

  if targets.len < 1:
    error "Specify an operation!"
    error "Run --help for more information"
    quit(1)

  let operation = targets[0]

  var dontInstall, dontConfigureUser, dontHandleHome, dontHandleScripts, dontHandleDotfiles: bool

  dontInstall = args.isSwitchEnabled("dont-install", "di")
  dontHandleHome = args.isSwitchEnabled("dont-handle-home", "dh")
  dontConfigureUser = args.isSwitchEnabled("dont-configure-user", "dcu")
  dontHandleScripts = args.isSwitchEnabled("dont-handle-scripts", "dhs")
  dontHandleDotfiles = args.isSwitchEnabled("dont-handle-dotfiles", "dhd")

  if args.isSwitchEnabled("dotfiles", "d"):
    dontInstall = true
    dontHandleHome = true
    dontConfigureUser = true
    dontHandleScripts = true
    dontHandleDotfiles = false

  if args.isSwitchEnabled("scripts", "s"):
    dontInstall = true
    dontConfigureUser = true
    dontHandleHome = true
    dontHandleScripts = false
    dontHandleDotfiles = true
  
  case operation:
    of "apply":
      if targets.len < 2:
        error "Specify a project directory to apply a config from"
        quit(1)

      let projectDir = targets[1]
      if not dirExists(projectDir):
        error "Specified project directory does not exist"
        quit(1)

      let project = newProject(projectDir)
      if not project.validate():
        error "Project validation failed. Are you sure that this is a valid project?"
        quit(1)
      else:
        info "Project validation was successful. Applying project to system."
      
      project.install(
        dontInstall, dontConfigureUser, dontHandleScripts, dontHandleDotfiles,
        dontHandleHome
      )
    of "upgrade":
      if targets.len < 2:
        error "Specify a project directory to apply a config from"
        quit(1)

      let projectDir = targets[1]

      if not dirExists(projectDir):
        error "Specified project directory does not exist"
        quit(1)

      let project = newProject(projectDir)
      
      if not project.validate():
        error "Project validation failed. Are you sure that this is a valid project?"
        quit(1)
      else:
        info "Project validation was successful. Applying upgraded project to system."
        project.update()
    of "validate":
      if targets.len < 2:
        error "Specify a project directory to validate"
        quit(1)

      let projectDir = targets[1]

      if not dirExists(projectDir):
        error "Specified project directory does not exist"
        quit(1)

      let project = newProject(projectDir)
      
      info "Validating project."
      if not project.validate():
        error "Project validation failed. All errors have been displayed above."
        quit(1)
      else:
        info "Project validation was successful! Please mind that this does not ensure that all operations will be successful as it is near-impossible to validate commands for every package manager."
        quit(0)
    of "create":
      if targets.len < 2:
        error "Specify a project directory"
        quit(1)

      let projectDir = targets[1]

      createDefaultProject(projectDir)
    else:
      error "Invalid operation! Run --help for more information"
      quit(1)

when isMainModule:
  main()
