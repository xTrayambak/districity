# Package

version       = "0.1.0"
author        = "xTrayambak"
description   = "Reproducable builds without the woes of Nix"
license       = "MPL2"
srcDir        = "src"
bin           = @["districity"]


# Dependencies

requires "nim >= 2.0.0"
requires "chronicles"
requires "toml_serialization"
requires "pretty"
