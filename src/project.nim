import std/[os, tables, logging]

type
  Dotfile* = ref object of RootObj
    package*: string
    files*: tuple[belongs, filename: string]

  Project* = ref object of RootObj
    root*: string

    preBuiltPaths*: tuple[home, init, packages: string]

    runtimePaths*: TableRef[string, string]

    dotfiles*: TableRef[string, Dotfile]

proc validate*(project: Project): bool =
  result = true

  if not project.preBuiltPaths.init.fileExists():
    error "init.toml does not exist in project structure."
    result = false

  if not project.preBuiltPaths.home.fileExists():
    error "home.toml does not exist in project structure."
    result = false

  if not project.preBuiltPaths.packages.fileExists():
    error "packages.toml does not exist in project structure."
    result = false

proc newProject*(dir: string): Project =
  var project = Project()
  project.root = dir

  project.preBuiltPaths =
    (home: dir / "home.toml", init: dir / "init.toml", packages: dir / "packages.toml")

  project.runtimePaths = newTable[string, string]()
  project.dotfiles = newTable[string, Dotfile]()

  project
