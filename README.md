# `flatpak` cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/selnux.svg)](https://supermarket.chef.io/cookbooks/flatpak)
[![CI State](https://github.com/detjensrobert/flatpak-cookbook/workflows/ci/badge.svg)](https://github.com/detjensrobert/flatpak-cookbook/actions?query=workflow%3Aci)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

## Description

Chef cookbook for managing [Flatpak](https://github.com/flatpak/flatpak) applications.

## Notes

Currently, this cookbook only supports installing apps system-wide, and not per-user installs.

## Requirements

- Chef 15.3 or higher

## Platform

- CentOS 7+ (incl. Stream / Rocky / Alma)
- Amazon Linux 2
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

flatpak_app 'org.clementine_player.Clementine'
flatpak_app 'org.mozilla.firefox'
```

> **Note:** If the node is on a slow connection (e.g. < 1MB/s), the first `flatpak_app` install may time out and Chef will fail, as it will need to download the shared runtimes in addition to the application. If this happens, run Chef again and Flatpak will resume downloading where it left off.

## Contributing

PRs welcome!
