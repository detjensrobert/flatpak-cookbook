# `flatpak` cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/selnux.svg)](https://supermarket.chef.io/cookbooks/flatpak)
[![CI State](https://github.com/detjensrobert/flatpak-cookbook/workflows/ci/badge.svg)](https://github.com/detjensrobert/flatpak-cookbook/actions?query=workflow%3Aci)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)


> ⚠️ **WARNING**: Work in progress!
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

- [`flatpak_install`](documentation/install.md) - Set up Flatpak
- [`flatpak_remote`](documentation/remote.md) - Configure remotes
- [`flatpak_app`](documentation/app.md) - Install applications

## Minimal Example

```rb
flatpak_install 'example'
# ^ also configures flathub remote by default

flatpak_app 'org.clementine_player.Clementine'
flatpak_app 'org.mozilla.firefox'
```

> **Note:** If the node is on a slow connection (e.g. < 1MB/s), the install command `shell_out` may time out when installing applications and Chef will fail. If this happens, run Chef again and Flatpak will pick up the install where it left off.

## Contributing

PRs welcome!
