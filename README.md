sysctl cookbook
===============
[![Build Status](https://travis-ci.org/onehealth-cookbooks/sysctl.png?branch=master)](https://travis-ci.org/onehealth-cookbooks/sysctl)
[![Gitter chat](https://badges.gitter.im/onehealth-cookbooks/sysctl.png)](https://gitter.im/onehealth-cookbooks/sysctl)

Description
===========

Set [sysctl](http://en.wikipedia.org/wiki/Sysctl) system control parameters via Chef


Platforms
=========

* Debian/Ubuntu
* RHEL/CentOS
* Scientific Linux
* PLD Linux (not tested)

Usage
=======

There are two main ways to interact with the cookbook. This is via chef [attributes](http://docs.opscode.com/essentials_cookbook_attribute_files.html) or via the provided [LWRP](http://docs.opscode.com/lwrp.html).

## Attributes

  * `node.sysctl.params`  
    _default_: `{}`  
    A namespace for declaring sysctl parameters, expects nested
    attributes i.e.  `node.sysctl.params.net.core.somaxconn`
  * `node.sysctl.conf_file`  
    _default_ depends on platform, check `attributes/default.rb`
    Specifies the sysctl.d file to be used, the default is provided
    only for the Debian, Fedora FreeBSD and RHEL platform families, on other
    systems, it will default to `nil`.
  * `node.sysctl.allow_sysctl_conf`  
    _default_: `false`  
    Using `conf_file` is highly recommended. On some platforms that is
    not supported. For those platforms, set this to `true` and the
    cookbook will rewrite the `/etc/sysctl.conf` file directly with the
    params provided. Be sure to save any local edits of
    `/etc/sysctl.conf` before enabling this to avoid losing them.

## LWRP

### sysctl

Actions

- apply (default)
- remove
- save
- nothing

Attributes

- parameters

## Persistence rules

sysctl values will be persisted to the filesystem (so that they can be
initialized at boot) in the following cases, the first condition that
passes takes precedence:

attribute                       | condition | location
--------------------------------|-----------|----------------------------------
`node.sysctl.conf_file`         | defined   | `node.sysctl.conf_file`
`node.sysctl.allow_sysctl_conf` | is `true` | `/etc/sysctl.conf`

**If neither of the conditions is met, the values will not be persisted.**

## Examples

```rb
# set via attributes
node.default.sysctl.params.vm.swappiness = 20

# set multiple values via sysctl LWRP
sysctl 'multiple' do
  params 'vm.swappiness' => 20, 'net.core.somaxconn' => 1024
end

# set nested values via sysctl LWRP
sysctl 'nested' do
  params vm: { swappiness: 20 }, net: { core: { somaxconn: 1024 } }
end

# remove sysctl parameters, they will return to their default values
# after the persistence file is next written
sysctl 'cleanup' do
  params ['net.ipv4.tcp_fin_timeout', 'vm.swappiness']
  action :remove
end

# immediately persist all values to file (if possible, see persistence
# rules) rather than wait for the end of the chef run
sysctl 'persist' do
  action :save
end

# immediately persist and add new values
sysctl 'persist-plus' do
  params 'net.ipv4.tcp_fin_timeout' => 20
  action :save
end
```

## Ohai Plugin

The cookbook also includes an Ohai 7 plugin that can be installed by adding `sysctl::ohai_plugin` to your run\_list. This will populate `node['sys']` with automatic attributes that mirror the layout of `/proc/sys`.

To see ohai plugin output manually, you can run `ohai -d /etc/chef/ohai_plugins sys` on the command line.

# Development

We have written unit tests using [chefspec](http://code.sethvargo.com/chefspec/) and integration tests in [serverspec](http://serverspec.org/) executed via [test-kitchen](http://kitchen.ci).
Much of the tooling around this cookbook is exposed via guard and test kitchen, so it is highly recommended to learn more about those tools.

## Vagrant Plugin Dependencies

The integration tests can be run via test-kitchen using vagrant, but it depends on the following vagrant plugins:

```
vagrant plugin install vagrant-omnibus
```

Tested with 
* Vagrant (version 1.6.1)
* vagrant-omnibus (1.4.1)

## Running tests

The following commands will run the tests:

```
bundle install
bundle exec rubocop
bundle exec foodcritic .
bundle exec rspec
bundle exec kitchen test default-ubuntu-1404
bundle exec kitchen test default-centos-65
```

The above will do ruby style ([rubocop](https://github.com/bbatsov/rubocop)) and cookbook style ([foodcritic](http://www.foodcritic.io/)) checks followed by rspec unit tests ensuring proper cookbook operation. Integration tests will be run next on two separate linux platforms (Ubuntu 14.04 LTS Precise 64-bit and CentOS 6.5). Please run the tests on any pull requests that you are about to submit and write tests for defects or new features to ensure backwards compatibility and a stable cookbook that we can all rely upon.

## Running tests continuously with guard

This cookbook is also setup to run the checks while you work via the [guard gem](http://guardgem.org/).

```
bundle install
bundle exec guard start
```

## ChefSpec LWRP Matchers

The cookbook exposes a chefspec matcher to be used by wrapper cookbooks to test the cookbooks LWRP. See `library/matchers.rb` for basic usage.

# Links

There are a lot of different documents that talk about system control parameters, the hope here is to point to some of the most useful ones to provide more guidance as to what the possible kernel parameters are and what they mean.

* [Linux Kernel Sysctl](https://www.kernel.org/doc/Documentation/sysctl/)
* [Linux Kernel IP Sysctl](http://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)
* [THE /proc FILESYSTEM (Jun 2009)](http://www.kernel.org/doc/Documentation/filesystems/proc.txt)
* [RHEL 5 VM/Page Cache Tuning Presentation (2009) pdf](http://people.redhat.com/dshaks/Larry_Shak_Perf_Summit1_2009_final.pdf)
* [Arch Linux SysCtl Tutorial (Feb 2013)](http://gotux.net/arch-linux/sysctl-config/)
* [Old RedHat System Tuning Overview (2001!)](http://people.redhat.com/alikins/system_tuning.html)
* [Tuning TCP For The Web at Velocity 2013 (video)](http://vimeo.com/70369211), [slides](http://cdn.oreillystatic.com/en/assets/1/event/94/Tuning%20TCP%20For%20The%20Web%20Presentation.pdf)
* [Adventures in Linux TCP Tuning (Nov 2013)](http://thesimplecomputer.info/adventures-in-linux-tcp-tuning-page2/)
* [Part 1: Lessons learned tuning TCP and Nginx in EC2 (Jan 2014)](http://engineering.chartbeat.com/2014/01/02/part-1-lessons-learned-tuning-tcp-and-nginx-in-ec2/)
* [How to harden a new server with Chef](http://lollyrock.com/articles/how-to-harden-a-new-server/) about the [TelekomLabs Hardening Framework](http://telekomlabs.github.io/) (May 2014)
