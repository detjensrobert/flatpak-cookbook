# `flatpak` cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/selnux.svg)](https://supermarket.chef.io/cookbooks/flatpak)
[![CI State](https://github.com/detjensrobert/flatpak-cookbook/workflows/ci/badge.svg)](https://github.com/detjensrobert/flatpak-cookbook/actions?query=workflow%3Aci)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)


> ⚠️ **WARNING**: WIP
>
> This cookbook is still under development! Things may be not working and poorly documented!


## Description

Chef cookbook for managing [Flatpak](https://github.com/flatpak/flatpak) applications.

## Notes

Currently, this cookbook only supports installing apps system-wide, and not per-user installs.

## Requirements

- Chef 15.3 or higher

## Platform

- CentOS 7+ (incl. Stream / Rocky / Alma)
- Fedora
- Ubuntu 18.04+
- Debian 10+

## Resources

- [`flatpak_install`](documentation/install.md`)
- [`flatpak_remote`](documentation/remote.md`)
- [`flatpak_app`](documentation/app.md`)

## Contributing

PRs welcome!
