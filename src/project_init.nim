import std/[osproc]
import project, schemas, chronicles

proc handleInit*(project: Project, init: InitFileSchema) =
  let user = init.user

  info "Setting up user!", user=user.name
  let password = user.defaultPassword
  let code = execCmd("useradd " & user.name & " -p " & password)

  if code != 0:
    error "Could not create user."

  for group in user.groups:
    let code = execCmd("sudo usermod " & user.name & " -aG " & group)

    if code != 0:
      error "Could not add user to group. This might result in a broken system."

  info "Set-up all users."
