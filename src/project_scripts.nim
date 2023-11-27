import std/[os, random, osproc, strutils], chronicles, project

# TODO(xTrayambak): add support for more languages. Currently, only the following languages
# are supported.
# Nim, C, C++ and Rust
proc handleScriptFile*(path: string): bool =
  info "Handling script", file = path

  if path.endsWith("nim"):
    info "Compiling Nim code for script!", file = path
    if execCmd(
      "nim c -d:release -d:lto -d:speed -o:" & path.changeFileExt("") & ' ' & path
    ) != 0:
      error "Compilation failed for Nim binary", file = path
      return false
  elif path.endsWith("c") or path.endsWith("cpp") or path.endsWith("cxx"):
    info "Compiling C/C++ code for script!", file = path
    if execCmd(
      "gcc -o " & path.changeFileExt("") & " -O2 " & path
    ) != 0:
      error "Compilation failed for C/C++ binary", file = path
      return false
  elif path.endsWith("rs") or path.endsWith("skill-issue"):
    info "Compiling Rust code for script!", file = path
    if execCmd(
      "rustc -C opt-level=3 " & path & " -o:" & "scripts" / path
    ) != 0:
      error "Compilation failed for Rust binary", file = path
      
      if rand(0..255) > 250:
        error "You might wanna try out Nim, C, or C++, they're waaay better."
        error "Just saying! ;)"

      return false
  elif path.endsWith("py") or path.endsWith("sh") or path.endsWith("zsh") or path.endsWith("bash"):
    info "Ignoring interpreter-bound scripts.", file = path
  else:
    let splitted = splitFile(path)

    if splitted.ext != "" and splitted.ext != ".o" and splitted.ext != ".elf":
      error "Unhandled file type, script will not be compiled. Report this to the developers along with the language that the script is written in.", file = path
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
