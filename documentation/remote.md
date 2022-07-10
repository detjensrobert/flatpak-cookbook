[Back to resource list](../README.md#resources)

# flatpak_app

Configures Flatpak remotes. Equivalent of the `flatpak-remote-*` commands.

## Actions

| Action    | Description                                               |
|-----------|-----------------------------------------------------------|
| `:add`    | *(Default)* Adds the remote to the Flatpak config         |
| `:remove` | Removes the remote and any applications installed from it |

## Properties

| Name            | Type    | Default         | Description                                                                                                                                                                                           |
|-----------------|---------|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `remote_name`   | String  | (resource name) | Name of the remote to configure                                                                                                                                                                       |
| `location`      | String  |                 | Location of a `.flatpakrepo` file, either a URL or file path. This is what is normally passed to `flatpak remote-add`.                                                                                |
| `url`           | String  |                 | `*` Manually set the remote repository URL.                                                                                                                                                           |
| `title`         | String  |                 | `*` Display title for the remote                                                                                                                                                                      |
| `comment`       | String  |                 | `*` Short description                                                                                                                                                                                 |
| `description`   | String  |                 | `*` Long description                                                                                                                                                                                  |
| `homepage`      | String  |                 | `*` URL of the remote's website                                                                                                                                                                       |
| `icon`          | String  |                 | `*` URL of an icon for the remote                                                                                                                                                                     |
| `gpgkey`        | String  |                 | `*` GPG key for verification, base64-encoded.                                                                                                                                                         |
| `collection_id` | String  |                 | `*` Used to identify remotes for P2P                                                                                                                                                                  |
| `filters`       | Array   |                 | Array of filter lines to apply to the remote. See [upstream `flatpak-remote-add --filter` docs](https://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-remote-add) for the format. |
| `priority`      | Integer | 1               | Priority of the remote. Higher number is more preferred.                                                                                                                                              |

Either `location` or `url` are required for `:install`.

Properties marked with `*` are for manually configuring a `.flatpakrepo` file. See [upstream documentation](https://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-flatpakrepo) on the format.

## Examples

```ruby
# how flathub is configured in flatpak_install
flatpak_remote 'flathub' do
  location 'https://flathub.org/repo/flathub.flatpakrepo'
end

# configure with manual parameters
flatpak_remote 'fedora' do
  url 'oci+https://registry.fedoraproject.org'
  title 'Fedora Flatpaks'
  comment 'Flatpaks built by the Fedora project'
  homepage 'https://src.fedoraproject.org/projects/flatpaks/*'
end

# filter remote to only show a subset of apps (e.g. just org.fedoraproject.*)
flatpak_remote 'fedora' do
  url 'oci+https://registry.fedoraproject.org'
  filters [
    'deny *',
    'allow org.fedoraproject.*'
  ]
end

# remove a remote (will also uninstall any apps installed from it)
flatpak_remote 'fedora' do
  action :remove
end
```
