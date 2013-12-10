## v0.3.5

* Scientific Linux 6 support confirmed
* [GH-16] Document and test lwrp action :nothing
* Update to test kitchen 1.1
* Update to vagrant 1.4
* Added CentOS 5.10 and 6.5 test boxes

## v0.3.4

* [GH-9] Make changes available immediately (Warren Vosper)
* [GH-8] Added PLD Linux support (not regularily tested) (Elan Ruusam?e)
* Switch to rubocop over tailor
* Modernize Gemfile dependencies and add Guard for development
* Fix FC048: Prefer Mixlib::ShellOut

## v0.3.3

* More explicitly define conflicting cookbooks and operating systems in metadata.rb
* [GH-6] Fixed any params with spaces throw errors (Mike Pavlenko)

## v0.3.2

* [GH-5] Fixed ImmutableAttributeModification (Mark Pimentel)
* Added LWRP integration tests for test kitchen
* LWRP now sets attributes on the node via node.default, not node.set allowing easier overrides by other cookbooks

## v0.3.1

* Added attribute integration tests for test kitchen
* Added alpha RHEL/CentOS support
* Added Travis CI Builds
* Cleaned up foodcritic and tailor complaints

## v0.3.0

There is a lot of talk about making one sysctl cookbook. Let's make it happen.

* BREAKING CHANGE: use sysctl.params instead of sysctl.attributes to match LWRP and sysctl standard naming
* [GH-1] Remove 69-chef-static.conf
* New Maintainer: Sander van Zoest, OneHealth
* Update Development environment with Berkshelf, Vagrant, Test-Kitchen

## v0.2.0:

* [FB-3] - Notify procps start immediately
* [FB-4] - Dynamic configuration file. Add LWRP.
* [FB-5] - Allow Bignums as values
