# sysctl cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/sysctl.svg?style=flat)](https://supermarket.chef.io/cookbooks/sysctl) [![Build Status](https://travis-ci.org/sous-chefs/sysctl.svg?branch=master)](https://travis-ci.org/sous-chefs/sysctl) [![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

Set [sysctl](http://en.wikipedia.org/wiki/Sysctl) system control parameters via Chef

## Requirements

### Platforms

- Debian/Ubuntu (Integration tested)
- RHEL/CentOS (Integration tested)
- PLD Linux
- Exherbo
- Arch Linux
- openSUSE
- FreeBSD

### Chef

- 12.5+

## Usage

There are two main ways to interact with the cookbook. This is via chef [attributes](http://docs.chef.io/attributes.html) or via the resource.

### Cookbook Attributes

- `node['sysctl']['params']` - A namespace for setting sysctl parameters.
- `node['sysctl']['conf_dir']` - Specifies the sysctl.d directory to be used. Defaults to `/etc/sysctl.d` on the Debian and RHEL platform families, otherwise `nil`
- `node['sysctl']['allow_sysctl_conf']` - Defaults to false. Using `conf_dir` is highly recommended. On some platforms that is not supported. For those platforms, set this to `true` and the cookbook will rewrite the `/etc/sysctl.conf` file directly with the params provided. Be sure to save any local edits of `/etc/sysctl.conf` before enabling this to avoid losing them.
- `node['sysctl']['restart_procps']` - Defaults to true. Will allow the consumer of the cookbook to control whether or not to notify procps to restart sysctl to load the newly set values.

Note: if `node['sysctl']['conf_dir']` is set to nil and `node['sysctl']['allow_sysctl_conf']` is not set, no config will be written

### Setting Sysctl Parameters

#### Using Attributes

Setting variables in the `node['sysctl']['params']` hash will allow you to easily set common kernel parameters across a lot of nodes. All you need to do to have them loaded is to include `sysctl::apply` anywhere in your run list of the node. It is recommended to do this early in the run list, so any recipe that gets applied afterwards that may depend on the set parameters will find them to be set.

The attributes method is easiest to implement if you manage the kernel parameters at the system level opposed to a per cookbook level approach. The configuration will be written out when `sysctl::apply` gets run, which allows the parameters set to be persisted during a reboot.

#### Examples

Set `vm.swappiness` to 20 via attributes

```ruby
    node.default['sysctl']['params']['vm']['swappiness'] = 20

    include_recipe 'sysctl::apply'
```

### Using resources

The `sysctl_param` resource can be called from wrapper or application cookbooks to immediately set the kernel parameter and cue the kernel parameter to be written out to the configuration file.

This also requires that your run_list include the `sysctl::default` recipe in order to persist the settings.

### sysctl_param

#### Actions

- `:apply` (default)
- `:remove`
- `:nothing`

#### Properties

- key
- value

#### Examples

Set vm.swappiness to 20 via sysctl_param resource

```ruby
    include_recipe 'sysctl::default'

    sysctl_param 'vm.swappiness' do
      value 20
    end
```

Remove sysctl parameter and set net.ipv4.tcp_fin_timeout back to default

```ruby
    sysctl_param 'net.ipv4.tcp_fin_timeout' do
      value 30
      action :remove
    end
```

### Ohai Plugin

The cookbook also includes an Ohai plugin that can be installed by adding `sysctl::ohai_plugin` to your run_list. This will populate `node['sys']` with automatic attributes that mirror the layout of `/proc/sys`.

To see Ohai plugin output manually, you can run `ohai -d /etc/chef/ohai/plugins sys` on the command line.

## Additional Reading

There are a lot of different documents that talk about system control parameters, the hope here is to point to some of the most useful ones to provide more guidance as to what the possible kernel parameters are and what they mean.

- [Chef OS Hardening Cookbook](https://github.com/dev-sec/chef-os-hardening)
- [Linux Kernel Sysctl](https://www.kernel.org/doc/Documentation/sysctl/)
- [Linux Kernel IP Sysctl](http://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)
- [Linux Performance links](http://www.brendangregg.com/linuxperf.html) by Brendan Gregg
- [RHEL 7 Performance Tuning Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/pdf/Performance_Tuning_Guide/Red_Hat_Enterprise_Linux-7-Performance_Tuning_Guide-en-US.pdf) by Laura Bailey and Charlie Boyle
- [Performance analysis & tuning of Red Hat Enterprise Linux at Red Hat Summit 2015 (video)](https://www.youtube.com/watch?v=ckarvGJE8Qc) slides [part 1](http://videos.cdn.redhat.com/summit2015/presentations/15284_performance-analysis-tuning-of-red-hat-enterprise-linux.pdf) by Jeremy Eder, D. John Shakshober, Larry Woodman and Bill Gray
- [Performance Tuning Linux Instances on EC2 (Nov 2014)](http://www.brendangregg.com/blog/2015-03-03/performance-tuning-linux-instances-on-ec2.html) by Brendan Gregg
- [Part 1: Lessons learned tuning TCP and Nginx in EC2 (Jan 2014)](http://engineering.chartbeat.com/2014/01/02/part-1-lessons-learned-tuning-tcp-and-nginx-in-ec2/)
- [Tuning TCP For The Web at Velocity 2013 (video)](http://vimeo.com/70369211), [slides](http://cdn.oreillystatic.com/en/assets/1/event/94/Tuning%20TCP%20For%20The%20Web%20Presentation.pdf) by Jason Cook
- [THE /proc FILESYSTEM (Jun 2009)](http://www.kernel.org/doc/Documentation/filesystems/proc.txt)

## Development

We have written unit tests using [chefspec](http://code.sethvargo.com/chefspec/) and integration tests in [serverspec](http://serverspec.org/) executed via [test-kitchen](http://kitchen.ci). Much of the tooling around this cookbook is exposed via guard and test kitchen, so it is highly recommended to learn more about those tools. The easiest way to get started is to install the [Chef Development Kit](https://downloads.chef.io/chef-dk/)

### Running tests

The following commands will run the tests:

```bash
chef exec bundle install
chef exec cookstyle
chef exec foodcritic .
chef exec rspec
chef exec kitchen test
```

Please run the tests on any pull requests that you are about to submit and write tests for defects or new features to ensure backwards compatibility and a stable cookbook that we can all rely upon.

### Running tests continuously with guard

This cookbook is also setup to run the checks while you work via the [guard gem](http://guardgem.org/).

```bash
bundle install
bundle exec guard start
```

### ChefSpec Resource Matchers

The cookbook exposes a ChefSpec matcher to be used by wrapper cookbooks to test the cookbooks resource. See `libraries/matchers.rb` for basic usage.
