# Starting off with configuring Districity
Let's get a project working!
Go to `init.toml`, and you'll see something like this:

```toml
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
```

## core
You can optionally change the `name` and `authors` variables.

## distro
This is crucial. Make sure to configure it properly. Search your distribution's package manager usage manual if you're not sure how the commands work.

You can optionally set `name` there.

## user
This is also crucial. Configure your user here.

# Wrapping up
Now, after you've completed the steps above, invoke districity:
```
$ districity apply /path/to/your/project/directory
```
and everything will be set up! We'll see how to install packages next.
