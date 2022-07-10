[Back to resource list](../README.md#resources)

# flatpak_install

Installs Flatpak and optionally configures the standard Flathub remote.

> **Note:**
>
> On older Ubuntu versions (20.04 and below), this resource uses a PPA to install a newer version of Flatpak, as
> [recommended by upstream](https://flatpak.org/setup/Ubuntu).

## Actions

| Action     | Description                                                         |
|------------|---------------------------------------------------------------------|
| `:install` | *(Default)* Installs the Flatpak package and required dependencies. |
| `:update`  | Updates the Flatpak package.                                        |
| `:remove`  | Uninstalls Flatpak.                                                 |

## Properties

| Name                | Type | Default | Description                                                                     |
|---------------------|------|---------|---------------------------------------------------------------------------------|
| `configure_flathub` | Bool | `true`  | Configures [Flathub](https://flathub.org) as a flatpak remote after installing. |

## Examples

```ruby
flatpak_install 'example'

# Don't automatically configure flathub
flatpak_install 'noflathub' do
  configure_flathub false
end
```
