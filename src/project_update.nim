import std/osproc
import project, schemas, project_install, chronicles

proc update*(project: Project) =
  let initData = project.preBuiltPaths.init
    .readFile()
    .initFileSchema()

  let upgradeCode = execCmd(initData.distro.packageSyncRepos)

  if upgradeCode != 0:
    error "Project packages upgrade returned non-zero exit code. Cannot continue.", code = upgradeCode
    return
  
  info "Project packages have been updated successfully, applying project to system."
  project.install()
