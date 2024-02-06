import std/tables, toml_serialization

type
  ## Default
  BaseFileSchema* = TableRef[string, Table[string, TomlValueRef]]

  ## init.toml
  InitCore* = object
    name*: string
    authors*: string

  InitDistro* = object
    name*: string
    packageSyncRepos*: string
    packageInstallCmd*: string
    packageUninstallCmd*: string

  InitUser* = object
    name*: string
    groups*: seq[string]
    defaultPassword*: string

  InitFileSchema* = object
    core*: InitCore
    distro*: InitDistro
    user*: InitUser

  ## home.toml
  HomeEnv* = object
    shell*: string
    rc*: string
    oh_my_zsh*: bool
    env*: seq[string]

  HomeFileSchema* = object
    home*: HomeEnv

  ## packages.toml
  PackagesCore* = object
    programs*: seq[string]
    imports*: seq[string]

  PackagesFileSchema* = object
    core*: PackagesCore

  ## Generic schema for configuration files
  GenericConfig* = object
    uses*: string ## xdg config path or another directory
    belongsTo*: string

  GenericConfigFileSchema* = object
    config*: GenericConfig

  NimbleCore* = object
    packages*: seq[string]

  NimbleConfigFileSchema* = object
    core*: NimbleCore

proc initFileSchema*(data: string): InitFileSchema =
  let core = Toml.decode(data, InitCore, "core", TomlCaseNim)
  let distro = Toml.decode(data, InitDistro, "distro", TomlCaseNim)
  let user = Toml.decode(data, InitUser, "user", TomlCaseNim)

  InitFileSchema(core: core, distro: distro, user: user)

proc homeFileSchema*(data: string): HomeFileSchema =
  let home = Toml.decode(data, HomeEnv, "home", TomlCaseNim)

  HomeFileSchema(home: home)

proc packagesFileSchema*(data: string): PackagesFileSchema =
  let core = Toml.decode(data, PackagesCore, "core", TomlCaseNim)

  PackagesFileSchema(core: core)

proc genericConfigFileSchema*(data: string): GenericConfigFileSchema =
  let config = Toml.decode(data, GenericConfig, "config", TomlCaseNim)

  GenericConfigFileSchema(config: config)

proc nimbleConfigFileSchema*(data: string): NimbleConfigFileSchema =
  let core = Toml.decode(data, NimbleCore, "core", TomlCaseNim)

  NimbleConfigFileSchema(core: core)
