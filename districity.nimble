# Package

version       = "0.1.0"
author        = "xTrayambak"
description   = "Reproduceable builds without the woes of Nix"
license       = "WTFPL"
srcDir        = "src"
bin           = @["districity"]


# Dependencies

requires "nim >= 2.0.0"
requires "toml_serialization >= 0.2.12"
requires "colored_logger >= 0.1.0"
requires "nph >= 0.3.0"

task fmt, "Format code":
  exec "nph src/"
