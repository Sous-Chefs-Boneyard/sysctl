Description
===========

Set [sysctl](http://en.wikipedia.org/wiki/Sysctl) System Control parameters via Opscode Chef

# Requirements

## Platform:

* Debian/Ubuntu
* RHEL/CentOS

Recipes
=======
# Usage


## Attributes

* node['sysctl']['attributes'] - A namespace for sysctl settings.
  For example: node['sysctl']['attributes']['vm']['swappiness'] = 20

* node['sysctl']['conf_dir']  - Specifies the sysctl.d directory to be used. Defaults on Debian to /etc/sysctl.d, otherwise nil
* node['sysctl']['allow_sysctl_conf'] - Defaults to false. This will write params to /etc/sysctl.conf directly when set to true.

## LWRP

### sysctl_param

Actions

- apply (default)
- remove

Attributes

- key
- value

## Examples

sysctl_param 'vm.swappiness' do
  value 20
end

sysctl_param 'net.ipv4.tcp_fin_timeout' do
  value 30
  action :remove
end

# Recipes

# Development

This cookbook can be tested using vagrant, but it depends on the following vagrant plugins

```
vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-berkshelf
```

Tested with 
* Vagrant (version 1.2.1)
* vagrant-berkshelf (1.2.0)
* vagrant-omnibus (1.0.2)

# System Control Links

There are a lot of different documents that talk about system control parameters, the hope here is to point to some of the most useful ones to provide more guidance as to what the possible parameters are and what they mean.

* [Arch Linux SysCtl Tutorial (Feb 2013)](http://gotux.net/arch-linux/sysctl-config/)
* [Linux Kernel IP Sysctl](http://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)
* [RHEL 5 VM/Page Cache Tuning Presentation (2009) pdf](http://people.redhat.com/dshaks/Larry_Shak_Perf_Summit1_2009_final.pdf)
* [Old RedHat System Tuning Overview (2001!)](http://people.redhat.com/alikins/system_tuning.html)

# Author

Author:: Sander van Zoest (<cookbooks@onehealth.com>)
