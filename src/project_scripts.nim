import std/[os, osproc, strutils, logging], project

# TODO(xTrayambak): add support for more languages. Currently, only the following languages
# are supported.
# Nim, C, C++ and Rust
proc handleScriptFile*(path: string): bool =
  info "Handling script: " & path

  if path.endsWith("nim"):
    if execCmd(
      "nim c -d:release -d:lto -d:speed -o:" & path.changeFileExt("") & ' ' & path
    ) != 0:
      error "Compilation failed for Nim binary: " & path
      return false
  elif path.endsWith("c") or path.endsWith("cpp") or path.endsWith("cxx"):
    if execCmd("gcc -o " & path.changeFileExt("") & " -O2 " & path) != 0:
      error "Compilation failed for C/C++ binary: " & path
      return false
  elif path.endsWith("rs") or path.endsWith("skill-issue"):
    if execCmd("rustc -C opt-level=3 " & path & " -o " & path.splitPath().tail) != 0:
      error "Compilation failed for Rust binary: " & path

      return false
  elif path.endsWith("py") or path.endsWith("sh") or path.endsWith("zsh") or
      path.endsWith("bash"):
    info "Ignoring interpreter-bound scripts."
  else:
    let splitted = splitFile(path)

    if splitted.ext != "" and splitted.ext != ".o" and splitted.ext != ".elf":
      error "Unhandled file type, script will not be compiled. Report this to the developers along with the language that the script is written in: " &
        path
      return false

  info "Compilation successful. Moving binary."
  let splitted = splitFile(path)
  moveFile(splitted.dir / splitted.name, getHomeDir() / ".scripts" / splitted.name)
  true

proc handleScripts*(project: Project) =
  if not dirExists(project.root / "scripts"):
    return

  info "Installing scripts"
  createDir(getHomeDir() / ".scripts")

  for kind, path in walkDir(project.root / "scripts"):
    if kind == pcFile:
      if not handleScriptFile(path):
        error "Cannot continue with handling scripts. Abort."
        quit(1)

      # copyFile(path, getHomeDir() / ".scripts/")

  info "Installed all scripts."
