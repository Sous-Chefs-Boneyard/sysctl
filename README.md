The sysctl resource from this cookbook is now shipping as part of Chef 14\. With the inclusion of this resource into Chef itself we are now deprecating this cookbook. It will continue to function for Chef 13 users, but will not be updated.

# sysctl cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/sysctl.svg?style=flat)](https://supermarket.chef.io/cookbooks/sysctl) [![Build Status](https://travis-ci.org/sous-chefs/sysctl.svg?branch=master)](https://travis-ci.org/sous-chefs/sysctl) [![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

Use the sysctl_param resource to set kernel parameters using the [sysctl](http://en.wikipedia.org/wiki/Sysctl) command line tool and configuration files in the system's sysctl.d directory. Configuration files managed by this resource are named 99-chef-KEYNAME.conf. If an existing value was already set for the value it will be backed up to the node and restored if the :remove action is used later.

**Please read the changelog when upgrading from the v0.x series to the v1.x series**

## Requirements

### Platforms

- Amazon Linux (Integration tested)
- Debian/Ubuntu (Integration tested)
- RHEL/CentOS (Integration tested)
- openSUSE (Integration tested)
- PLD Linux
- Exherbo
- Arch Linux
- SLES 12+

### Chef

- 12.7+

### sysctl_param

#### Actions

- `:apply` (default)
- `:remove`

#### Properties

`property`     | `type`                        | `description`
-------------- | ----------------------------- | ------------------------------------------------------------------------------------------------
`key`          | String                        | the path to the kernel parameter
`value`        | String, Integer, Float, Array | the value to set for the kernel parameter
`ignore_error` | True / False                  | Should the resource fail if setting the parameter via the `sysctl` command line was unsuccessful

#### Examples

Set vm.swappiness to 20 via sysctl_param resource

Include `sysctl` in your metadata.rb

```ruby
# metadata.rb

name 'my_app'
version '0.1.0'
depends 'sysctl'
```

Use the resource

```ruby
# recipes/default.rb
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

Add sysctl parameter but ignore errors if they arise

```ruby
sysctl_param 'kernel.randomize_va_space' do
  value 0
  ignore_error true
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

We have written unit tests using [chefspec](http://code.sethvargo.com/chefspec/) and integration tests in [InSpec](https://www.inspec.io//) executed via [test-kitchen](https://kitchen.ci/). Much of the tooling around this cookbook is exposed via guard and test kitchen, so it is highly recommended to learn more about those tools. The easiest way to get started is to install the [Chef Development Kit](https://downloads.chef.io/chefdk)

### Running tests

Install ChefDK from chefdk.io

```bash
# Run the unit & lint tests
chef exec delivery local all

# Run the integration suites
kitchen test
```
