import std/[os, osproc, httpclient, logging]

const NimblePkgVersion {.strdefine.} = "0.1.0"
const
  OMZ_URL {.strdefine.} =
    "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

proc installOmz*(shell: string): bool =
  when not defined(ssl):
    error "Districity was compiled without SSL support, getting shell scripts over a plaintext network is a security violation. (compile with -d:ssl)"
    return false

  info "Fetching Oh My Zsh bootstrap script."
  let client = newHttpClient(userAgent = "Districity/" & NimblePkgVersion)
  let path = "/tmp" / getEnv("USER") / "omz.sh"

  info "Downloading bootstrap script: " & OMZ_URL
  client.downloadFile(OMZ_URL, path)

  if execCmd(shell & ' ' & path) != 0:
    error "Failed to execute Oh My Zsh bootstrap script!"
    return false

  true
