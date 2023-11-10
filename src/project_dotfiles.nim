import std/os
import project, schemas, chronicles

proc handleDotfile*(project: Project, package: string, schema: GenericConfigFileSchema) =
  info "Handling dotfile", package=package

  let dir = case schema.config.uses:
  of "XDG":
    getConfigDir() / schema.config.belongsTo
  else: schema.config.uses / schema.config.belongsTo

  if not dirExists(project.root / package):
    warn "Config directory does not exist for package, dotfiles for it will not be handled!", package=package
    return
    
  for kind, path in walkDir(project.root / package):
    let tPath = dir / path.extractFilename()
    if not dirExists(dir):
      info "Creating config directory!", directory=dir
      createDir(dir)

    if kind == pcFile:
      copyFile(path, tPath)

  info "Placed dotfiles for package", package=package
