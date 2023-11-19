import std/os
import project, project_dotfiles, package, schemas, chronicles

proc handlePackages*(project: Project, init: InitFileSchema, packages: PackagesFileSchema, dryRun, dontHandleDotfiles: bool) =
  let core = packages.core

  for pkg in core.programs:
    if not dryRun:
      let package = Package(name: pkg)
      package.install(init)
    else:
      info "Not installing package (--dont-install is enabled)", package = pkg

    if fileExists(project.root / pkg & ".toml") and not dontHandleDotfiles:
      info "Analyzing extra config for package.", package = pkg
      let schema = readFile(project.root / pkg & ".toml")
        .genericConfigFileSchema()

      project.handleDotfile(pkg, schema)
    elif dontHandleDotfiles:
      info "Not handling dotfiles (--dont-handle-dotfiles is enabled)", package = pkg

  if core.imports.len > 0:
    info "Handling package import"
    for impFile in core.imports:
      if not fileExists(project.root / impFile):
        warn "Package import file not found, skipping.", file = impFile
        continue
      
      let file = (project.root / impFile)
        .readFile()
        .packagesFileSchema()

      project.handlePackages(init, file, dryRun, dontHandleDotfiles)
