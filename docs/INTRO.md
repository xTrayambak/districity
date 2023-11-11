# What is districity?
Districity is a tool to manage your packages, dotfiles and scripts in a reproduceable manner. \
Districity can be configured using TOML is very powerful once you get the gist of it. It is distro-agnostic (you can specify your package manager in the configuration, henceforth).

# Why?
Nix can be a daunting challenge for anyone to learn. I myself had a fairly bad time grasping Nix and especially, flakes. Here's an excerpt of my Nix dotfiles, showing my... uh.. let's say, bad time.
[epic gamer rage](docs/assets/programmer_rage.jpg)

Don't get me wrong, I still love Nix! The only reason I made this tool is because NixOS borked my system. I want something that isn't as deeply rooted inside the OS, basically working as a sort of "co-pilot" to your ordinary package manager. \

districity is also inspired by Oglo's `dister` tool, except districity has support for handling dotfiles slightly more easily.

# Who?
This is for people who don't want to write their configurations and dotfiles in Nix, and yet want it's ease of reproduceability. Learning districity is leaps easier than Nix. It uses the easy to grasp TOML language for defining things.

## You should use Districity if...
You're a r/unixporn addict and just want something to rice your system and carry it around in a small pendrive, plug it into a new computer, run a binary and boom, your system is back, up and running!

## You should use Nix if...
You're administrating a server. Districity is NOT made for servers. Period.

# Convinced yet?
If you are, then nice! You can continue to the next page.
