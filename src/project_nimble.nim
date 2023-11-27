import std/[os, osproc], project, schemas, chronicles

proc installNimble*(project: Project) =
  if not fileExists(project.root / "nimble.toml"):
    info "No configuration file was provided for Nimble, skipping installation of Nimble packages."
    return

  let nimbleData = readFile(project.root / "nimble.toml")
    .nimbleConfigFileSchema()

  for package in nimbleData.core.packages:
    info "Installing Nimble package!", package = package
    let code = execCmd("nimble install " & package)

    if code != 0:
      error "Failed to install Nimble package. Process returned non-zero exit code.", package = package, code = code

  info "Done installing Nimble packages."
