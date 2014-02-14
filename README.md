# sysctl [![Build Status](https://travis-ci.org/onehealth-cookbooks/sysctl.png?branch=master)](https://travis-ci.org/onehealth-cookbooks/sysctl)

Description
===========

Set [sysctl](http://en.wikipedia.org/wiki/Sysctl) system control parameters via Opscode Chef


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

* `node['sysctl']['params']` - A namespace for setting sysctl parameters
* `node['sysctl']['conf_dir']`  - Specifies the sysctl.d directory to be used. Defaults to `/etc/sysctl.d` on the Debian and RHEL platform families, otherwise `nil`
* `node['sysctl']['allow_sysctl_conf']` - Defaults to false.  Using `conf_dir` is highly recommended. On some platforms that is not supported. For those platforms, set this to `true` and the cookbook will rewrite the `/etc/sysctl.conf` file directly with the params provided. Be sure to save any local edits of `/etc/sysctl.conf` before enabling this to avoid losing them.

## LWRP

### sysctl_param

Actions

- apply (default)
- remove
- nothing

Attributes

- key
- value

## Examples

    # set vm.swapiness to 20 via attributes

    node.default['sysctl']['params']['vm']['swappiness'] = 20

    # set vm.swapiness to 20 via sysctl_param LWRP
    sysctl_param 'vm.swappiness' do
      value 20
    end

    # remove sysctl parameter and set net.ipv4.tcp_fin_timeout back to default
    sysctl_param 'net.ipv4.tcp_fin_timeout' do
      value 30
      action :remove
    end

# Development

We have written unit tests using [chefspec](http://code.sethvargo.com/chefspec/) and integration tests in [bats](https://github.com/sstephenson/bats) executed via [test-kitchen](http://kitchen.ci).
Much of the tooling around this cookbook is exposed via guard and test kitchen, so it is highly recommended to learn more about those tools.

## Vagrant Plugin Dependencies

The integration tests can be run via test-kitchen using vagrant, but it depends on the following vagrant plugins:

```
vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-berkshelf
```

Tested with 
* Vagrant (version 1.4.3)
* vagrant-berkshelf (1.3.5)
* vagrant-omnibus (1.1.2)

## Running tests

The following commands will run the tests:

```
bundle install
bundle exec rubocop
bundle exec foodcritic .
bundle exec rspec
bundle exec kitchen test default-ubuntu-1204
bundle exec kitchen test default-centos-65
```

The above will do ruby style ([rubocop](https://github.com/bbatsov/rubocop)) and cookbook style ([foodcritic](http://www.foodcritic.io/)) checks followed rspec unit tests ensuring proper cookbook operation.Integration tests will be run next on two separate linux platforms (Ubuntu 12.04 LTS Precise 64-bit and CentOS 6.5). Please run the tests on any pull requests that you are about to submit and write tests for defects or new features to ensure backwards compatibility and a stable cookbook that we can all rely upon.

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
