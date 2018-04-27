# Sysctl

## v1.0.5 (2018-04-27)

- Remove the last remains of the parameter backup functionality in the param resource
- Use more friendly resource names when reloading the sysctl values
- Fixed ignore_error to actually work and set it to not show up in reporting
- Simplified how we load the current value

## v1.0.4 (2018-04-07)

- The param resource from this cookbook is now shipping as part of Chef 14\. With the inclusion of this resource into Chef itself we are now deprecating this cookbook. It will continue to function for Chef 13 users, but will not be updated.

## v1.0.3 (2018-03-14)

- Refactor sysctl helpers into the correct files
- Hard fail on FreeBSD/SLEZ < 12 [#125](https://github.com/sous-chefs/sysctl/pull/125)

## v1.0.2 (2018-02-28)

- Removed sysctl collection in ohai for non-Linux hosts. This cookbook doesn't support it so we shouldn't increase ohai runtimes by collecting this data
- Removed the mention of attributes in the readme and put a large warning for users upgrading to 1.0
- Remove a debug statement that was left in the param resource
- Fixed the :remove action in the param resource to not converge when there isn't a entry to remove
- Increased the required Chef version to 12.7 since we're using action_class in the resource which had several bugs in 12.5/12.6

## v1.0.1 (2018-02-19)

- Add back systctl::default recipe, but log a warning that the recipe should be removed from cookbooks / runlists. Please update your cookbooks to require systctl 1 or later and remove this recipe.

## v1.0.0 (2018-02-17)

- Remove mentions of attributes
- `sysctl_param` now doesn't use attributes
- update ohai to 5+ to remove `compat_resource` dependency
- Move all helpers into helpers.rb
- Remove unused methods in the helpers
- Turn `template` into `cookbook_file`

### Behaviour Change

- Always ignore error when getting a key, that way the error is vomited back into the Chef run if there is one.
- Now use sysctl -p to set attributes This mean we can set/unset sysctl_param in one run.
- Fix reload resource for systemd
- No longer require `recipes:default` to be added to persist a parameter

## v0.10.2 (2017-09-17)

- Add attribute to handle with sysctl -e flag (#99)

## v0.10.1 (2017-08-07)

- Fix a typo in the helper that caused the cookbook to fail

## v0.10.0 (2017-07-31)

- Added support for Amazon Linux, Oracle Linux, and openSUSE
- Removed support for Ubuntu 14.10, Ubuntu <= 9.10, and Fedora < 18
- Resolved CHEF-19 Deprecation warnings that will impact Chef 14 runs
- Expanded Travis testing to more platforms and releases
- Removed problematic cdrom autoeject test that didn't work on all platforms
- Reenabled testing of FoodCritic rules FC059 and FC085
- Enabled testing of Chef deprecation warnings

## v0.9.0 (2017-05-18)

- This cookbook is now maintained by Sous-Chefs. See <http://sous-chefs.org/>
- Fixed 'ImmutableAttributeModification' error in remove_sysctl_param
- Added a new attribute `node['sysctl']['restart_procps']` to control restarting post change
- Removed deprecated "conflicts" metadata
- Updated the metadata license string to be a SPDX standard license string
- Removed Chef 11 compatibility in the metadata.rb file
- Switched testing to ChefDK instead of test gems in the Gemfile
- Converted ServerSpec tests to InSpec
- Updated ChefSpecs to test against the latest platform releases
- Added testing with Foodcritic and a .foodcritic file to ignore certain failures

## v0.8.1 (2016-10-29)

- [GH-64] Relax ohai cookbook dependency to >= 4
- Specify ohai version needs to be >= 8
- [GH-65] Use systemd-sysctl service for ubuntu > 15+

## v0.8.0 (2016-06-30)

- [GH-55] Update README with FreeBSD 10.3 support
- [GH-59] Update to ohai cookbook 4

This cookbook indirectly now requires Chef 12+. If you require Chef 11 support you'll need to pin to version 0.7.5 in your environment.

## v0.7.5 (2016-04-12)

- [GH-51] revert FC059: declare use_inline_resources

## v0.7.4 (2016-04-11)

- FC059: declare use_inline_resources

## v0.7.3 (2016-04-11)

- Added suse to metadata.rb
- Update gem and berkshelf cookbook dependencies

## v0.7.2 (2016-03-24)

- [GH-33] Addd initial Suse 11 & 12 support
- [GH-48] version pin 3.0 of the Ohai cookbook
- [GH-47] Rename key_path local var to key_path_tokens for clarity
- [GH-50] Resolves Rubocop complaint about nested ifs.
- [GH-46] Use fail instead of raise
- Update gem and berkshelf cookbook dependencies

## v0.7.0 (2015-12-03)

- Update gem and berkshelf cookbook dependencies
- Update documentation to suggest using chefdk for development
- Travis now uses ruby 2.1+
- [GH-8] Update README.md mentioning Archlinux and Exherbo
- [GH-38] Update to ServerSpec2
- [GH-36] ArchLinux fixes
- [GH-41] RHEL 7 Systemd support updates
- [GH-18] Added note on support for /etc/sysctl.d/ and using it on RHEL 6.2 or later.
- [GH-30] Add support for Ubuntu Vivid (15.04)
- [GH-16] Support ubuntu 14.10
- [GH-31] Adjust sysctl::apply to use :restart instead of :start for better systemd support

## v0.6.2 (2014-12-06)

- Fix rubocop error and packaging error

## v0.6.1 (2014-12-06)

- [GH-14] Update to chefspec 4.1 , rubocop 27, foodcritic 4

  ```
      Update matchers.rb for deprecated chefspec method.
  ```

- [GH-13] OneHealth was acquired by Viverae, update Gitter

- [GH-12] Update documentation to reflect inclusion of default recipe for LWRP

- Added initial FreeBSD support

- [GH-7] Added systemd based distros support

## v0.6.0 (2014-05-19)

- Rename `sysctl::persist` to `sysctl::apply` to more clearly reflect usage
- [GH-5] Improve immediate setting of attribute parameters during `sysctl::apply` run

## v0.5.6 (2014-05-16)

- Uploaded development version.

## v0.5.4 (2014-05-16)

- Manual upload

## v0.5.3 (2014-05-16)

- upload timed out to community cookbook for 0.5.2

## v0.5.2 (2014-05-16)

- Failed upload to community site

## v0.5.1 (2014-05-16)

- Now managed by [Stove](https://github.com/sethvargo/stove)

## v0.5.0 (2014-05-16)

- BREAKING CHANGE: For parameters to persist on reboot that are set via attributes, you now need to include `sysctl::persist` instead of `sysctl::default`. This allows LWRP users to use the cookbook without needing to load `sysctl::default` in their run list.
- Standardize on using Stove for community site management
- Updated Ubuntu tests to no longer test Lucid and focus on Precise and Trusty
- [GH-3] Improve idempotency with respect to sysctl config file when using lwrps (Michael S. Fischer)
- Added Ohai 7 plugin which exposes sysctl parameters via node['sys'] (Sander van Zoest, Guilhem Lettron)
- Fully switch to serverspec tests, added separate suites for attributes and lwrp invocation

## v0.4.0 (2014-04-04)

- [GH-24] On RHEL Adjust Init file to follow chkconfig standards (Alex Farhadi)
- [GH-22] lwrp parameters are written to the sysctl config file (Sander van Zoest, Guilhem Lettron)
- Entries in the sysctl config file are now sorted
- Removed Thor development dependency
- Added LWRP Matcher for use with ChefSpec by wrapper cookbooks
- Added ChefSpec 3 unit tests
- Ported bats tests to ServerSpec integration tests
- Use platform_family? in attributes (requires Ohai 0.6.12)
- Renamed ruby_block[sysctl config notifier] to ruby_block[save-sysctl-params] for clarity
- [GH-19] Make sysctl template logic idempotent (Roy Tewalt)

## v0.3.5 (2013-12-10)

- Scientific Linux 6 support confirmed
- [GH-16] Document and test lwrp action :nothing
- Update to test kitchen 1.1
- Update to vagrant 1.4
- Added CentOS 5.10 and 6.5 test boxes

## v0.3.4 (2013-11-04)

- [GH-9] Make changes available immediately (Warren Vosper)
- [GH-8] Added PLD Linux support (not regularily tested) (Elan Ruusam?e)
- Switch to rubocop over tailor
- Modernize Gemfile dependencies and add Guard for development
- Fix FC048: Prefer Mixlib::ShellOut

## v0.3.3 (2013-06-14)

- More explicitly define conflicting cookbooks and operating systems in metadata.rb
- [GH-6] Fixed any params with spaces throw errors (Mike Pavlenko)

## v0.3.2 (2013-05-24)

- [GH-5] Fixed ImmutableAttributeModification (Mark Pimentel)
- Added LWRP integration tests for test kitchen
- LWRP now sets attributes on the node via node.default, not node.set allowing easier overrides by other cookbooks

## v0.3.1 (2013-04-26)

- Added attribute integration tests for test kitchen
- Added alpha RHEL/CentOS support
- Added Travis CI Builds
- Cleaned up foodcritic and tailor complaints

## v0.3.0 (2013-04-23)

There is a lot of talk about making one sysctl cookbook. Let's make it happen.

- BREAKING CHANGE: use sysctl.params instead of sysctl.attributes to match LWRP and sysctl standard naming
- [GH-1] Remove 69-chef-static.conf
- New Maintainer: Sander van Zoest, OneHealth
- Update Development environment with Berkshelf, Vagrant, Test-Kitchen

## v0.2.0:

- [FB-3] - Notify procps start immediately
- [FB-4] - Dynamic configuration file. Add LWRP.
- [FB-5] - Allow Bignums as values
