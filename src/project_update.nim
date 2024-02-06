import std/[logging, osproc]
import project, schemas

proc update*(project: Project) =
  let initData = project.preBuiltPaths.init.readFile().initFileSchema()

  let upgradeCode = execCmd(initData.distro.packageSyncRepos)

  if upgradeCode != 0:
    error "Project packages upgrade returned non-zero exit code. Cannot continue."
    return

  info "Project packages have been updated successfully."
