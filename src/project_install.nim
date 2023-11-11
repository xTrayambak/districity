import std/[os, osproc], project, schemas,
       project_init, project_home, project_packages, project_scripts, 
       chronicles

proc install*(project: Project, dontInstall: bool = false) =
  info "Analyzing project, loading all files"
  let initFile = project.preBuiltPaths.init.readFile()
  let initData = initFileSchema(initFile)
  
  info "Setting up home environment and shell configuration"
  let homeFile = project.preBuiltPaths.home.readFile()
  let homeData = homeFileSchema(homeFile)
  
  info "Installing all packages and handling dotfiles"
  let packagesFile = project.preBuiltPaths.packages.readFile()
  let packagesData = packagesFileSchema(packagesFile)
  
  info "Loaded all files."
  
  info "Applying init file data."
  project.handleInit(initData)

  info "Applying home file data."
  project.handleHome(homeData)
  
  info "Applying packages file data."
  project.handlePackages(initData, packagesData, dontInstall)
  
  info "Applying scripts."
  project.handleScripts()

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
