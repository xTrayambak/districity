import std/[strutils, terminal], project, schemas

proc info*(project: Project) =
  let schema = project.preBuiltPaths.init
    .readFile()
    .initFileSchema()

  stdout.styledWriteLine(fgDefault, repeat('~', 64), fgYellow, "Core", fgDefault, repeat('~', 64), '\n')
  stdout.styledWriteLine(fgBlue, "project name", fgDefault, ": ", fgGreen, schema.core.name)
  stdout.styledWriteLine(fgBlue, "project author(s)", fgDefault, ": ", fgGreen, schema.core.author)

  stdout.styledWriteLine(repeat('~', 64), fgYellow, "Distro", fgDefault, repeat('~', 64), '\n')
  stdout.styledWriteLine fgBlue, "distribution", fgDefault, ": ", fgGreen, schema.distro.name, fgDe
  stdout.styledWriteLine fgBlue, "package install command", fgDefault, ": ", fgGreen, schema.distro.packageInstallCmd 
  stdout.styledWriteLine fgBlue, "package uninstall command", fgDefault, ": ", fgGreen, schema.distro.packageUninstallCmd
  stdout.styledWriteLine fgBlue, "package upgrade command", fgDefault, ": ", fgGreen, schema.distro.packageSyncRepos
