[Back to resource list](../README.md#resources)

# flatpak_app

Installs Flatpak applications and runtimes. Equivalent of `flatpak install`.

## Actions

| Action     | Description                                                        |
|------------|--------------------------------------------------------------------|
| `:install` | *(Default)* Installs the Flatpak application and required runtimes |
| `:update`  | Updates the application -- **not idempotent!**                     |
| `:remove`  | Uninstalls the application                                         |

## Properties

| Name     | Type   | Default         | Description                                                                                             |
|----------|--------|-----------------|---------------------------------------------------------------------------------------------------------|
| `ref`    | String | (resource name) | Name of the application to install. Either `the.application.Id` or `the.application.Id/{arch}/{branch}` |
| `remote` | String |                 | Remote to install the application from                                                                  |
| `flags`  | Array  |                 | Any additional command-line flags to use                                                                |


## Examples

```ruby
# set up flatpak and flathub remote
flatpak_install 'example'

# install from default remote
flatpak_app 'org.clementine_player.Clementine'

# install from specific remote
flatpak_app 'org.fedoraproject.MediaWriter' do
  remote 'fedora'
end

# remove app
flatpak_app 'com.discordapp.Discord' do
  action :remove
end

# prune unused runtimes (note empty app name)
flatpak_app '' do
  flags ['--unused']
  action :remove
end
```
