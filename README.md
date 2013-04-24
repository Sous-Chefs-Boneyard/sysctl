# sysctl cookbook

Set sysctl values from Chef!

# Requirements

# Usage

There are two ways of setting sysctl values:
# Set chef attributes in the _sysctl_ namespace, E.G.:
<tt>default[:sysctl][:vm][:swappiness] = 20</tt>
# Set values in a cookbook_file - 69-chef-static.conf

# Attributes

node[:sysctl] = A namespace for sysctl settings.

# Recipes

# Development

This cookbook can be tested using vagrant, but it depends on the following vagrant plugins

```
$ vagrant plugin install vagrant-omnibus
$ vagrant plugin install vagrant-berkshelf
```

Tested with 
* Vagrant (version 1.2.1)
* vagrant-berkshelf (1.2.0)
* vagrant-omnibus (1.0.2)

# Author

Author:: Sander van Zoest (<cookbooks@onehealth.com>)
