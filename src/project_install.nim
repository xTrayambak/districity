import std/[os, osproc], project, schemas,
       project_init, project_home, project_packages, project_scripts,
       project_nimble,
       chronicles

proc packageIsInstalled*(project: Project, pkg: string): bool =
  let packagesFile = project.preBuiltPaths.packages.readFile()
  let packagesData = packagesFileSchema(packagesFile)

  pkg in packagesData.core.programs

proc install*(project: Project, 
              dontInstall, dontHandleUsers, 
              dontHandleScripts, dontHandleDotfiles, 
              dontHandleHome: bool
) =
  info "Analyzing project, loading all files"
  let initFile = project.preBuiltPaths.init.readFile()
  let initData = initFileSchema(initFile)
  
  let homeFile = project.preBuiltPaths.home.readFile()
  let homeData = homeFileSchema(homeFile)
  
  let packagesFile = project.preBuiltPaths.packages.readFile()
  let packagesData = packagesFileSchema(packagesFile)
  
  info "Loaded all files."
  
  if not dontHandleUsers:
    info "Applying init file data."
    project.handleInit(initData)
  
  if not dontHandleHome:
    info "Applying home file data."
    project.handleHome(homeData, dontInstall)
  
  if not dontInstall:
    info "Applying packages file data."

  project.handlePackages(initData, packagesData, dontInstall, dontHandleDotfiles)

  if not dontInstall:
    project.installNimble()
  
  if not dontHandleScripts:
    info "Applying scripts."
    project.handleScripts()
  
  if not dontInstall:
    info "Installing districity."
    let res = execCmdEx(
      "sudo install -Dm755 " & 
      getAppFilename() & 
      " /usr/bin/districity")

    if res.exitCode != 0:
      error "Failed to install districity. You'll need to invoke this binary from this directory or add this directory to your PATH."
      echo res.output
      quit(1)

  info "Done."
