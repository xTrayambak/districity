import std/[osproc, logging], schemas, toml_serialization

type
  Package* = object
    name*: string

proc install*(package: Package, initConfig: InitFileSchema) =
  let installCmd = initConfig.distro.packageInstallCmd & ' '
  var res: tuple[output: string, exitCode: int]

  res = execCmdEx(installCmd & package.name)

  if res.exitCode != 0:
    error "[src/package.nim] Install failed: " & package.name
    echo "~> " & res.output
  else:
    info "[src/package.nim] Package installed successfully: " & package.name

proc fromString*(s: string): Package =
  Toml.decode(s, Package)
