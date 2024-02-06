import std/[logging, os]
import project, project_dotfiles, package, schemas

proc handlePackages*(
    project: Project,
    init: InitFileSchema,
    packages: PackagesFileSchema,
    dryRun, dontHandleDotfiles: bool,
) =
  let core = packages.core

  for pkg in core.programs:
    if not dryRun:
      let package = Package(name: pkg)
      package.install(init)

    if fileExists(project.root / pkg & ".toml") and not dontHandleDotfiles:
      info "Analyzing extra config for package: " & pkg
      let schema = readFile(project.root / pkg & ".toml").genericConfigFileSchema()

      project.handleDotfile(pkg, schema)

  if core.imports.len > 0:
    info "Handling package import"
    for impFile in core.imports:
      if not fileExists(project.root / impFile):
        warn "Package import file not found, skipping: " & impFile
        continue

      let file = (project.root / impFile).readFile().packagesFileSchema()

      project.handlePackages(init, file, dryRun, dontHandleDotfiles)
