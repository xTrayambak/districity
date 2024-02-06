import std/[logging, os]

const
  DEFAULT_INIT =
    """
# The core config, doesn't really matter what you put here.
[core]
name = "Example Config"
authors = "Your Name"

# Important info about your distro.
# If you add incorrect things to the last three attributes, districity will not work
# as intended.
[distro]
name = "The Linux distro you are using"
package_sync_repos = "The command to update your system"
package_install_cmd = "The command to install a package"
package_uninstall_cmd = "The command to remove a package"

# Important info about the main user.
# Your username, your default password (change it later if your dotfiles will be open source!)
# and the groups you're in.
[user]
name = "Your Username"
default_password = "districity"
groups = ["wheel", "kvm", "audio", "input"]
"""
  DEFAULT_HOME =
    """
# Your "home" (/home/your_username) configuration.
# Configure your shell, whether you want to use oh my zsh, your environment variables
# and your shell RC file.
# 
# WARNING: Don't add things to ~/.<yourshell>rc manually. Districity will wipe that out
# with each apply invocation. Add them here instead.
[home]
shell = "zsh"
oh_my_zsh = true
env = [
  "GTK_THEME=Adwaita-dark"
]
rc = ""
"""
  DEFAULT_PACKAGES =
    """
# All the packages you want.
# Add all of those to the programs list.
#
# In the imports list, add path names that you want districity to consider as package lists
# as well. They will need to use the same syntax/schema as this file.
[core]
programs = [
  "linux",
  "gcc",
  "clang"
]

imports = []
"""

proc isEmpty(dir: string): bool {.inline.} =
  for _, _ in walkDir(dir):
    return false

  true

proc createDefaultProject*(dirName: string) =
  if dirExists(dirName) and not isEmpty(dirName):
    error "Directory already exists and is not empty: " & dirName
    quit(1)

  discard existsOrCreateDir(dirName)

  info "Adding all core files."

  info "Writing init file."
  let initFile = open(dirName / "init.toml", fmWrite)
  defer:
    initFile.close()

  initFile.write(DEFAULT_INIT)

  info "Writing home file."
  let homeFile = open(dirName / "home.toml", fmWrite)
  defer:
    homeFile.close()

  homeFile.write(DEFAULT_HOME)

  info "Writing packages file."
  let packagesFile = open(dirName / "packages.toml", fmWrite)
  defer:
    packagesFile.close()

  packagesFile.write(DEFAULT_PACKAGES)

  info "A base project has been successfully created. It will not work right now."
  info "You will need to modify init.toml as instructed in the file to work with your distribution."
  info "Good luck! :>"
  quit(0)
