# provides :flatpak_remote
unified_mode true

property :remote_name, String, name_property: true,
          description: 'Name of the remote to configure'

property :location, String

property :url, String
property :title, String
property :comment, String
property :description, String
property :homepage, String
property :icon, String
property :gpgkey, String

property :priority, Integer,
          coerce: proc { |p| p.to_i },
          description: 'Priority for the configured remote, higher will be chosen first'

property :subset, String

# property :filter, Array, default: [],
#           description: 'List of filters to apply, see flatpak-remote-add docs'

property :flags, Array, default: [],
          coerce: proc { |p| p.sort },
          description: 'Additional CLI flags to specify when creating the repo'

# property :user, [true, false], default: false,
#           description: 'Use the per-user configuration instead of system-wide'

# podman output columns vs. flag names
# alias_method :url, :location

load_current_value do |new_resource|
  remotes = flatpak_get_remotes
  if remotes.key?(new_resource.remote_name)
    remotes[new_resource.remote_name].each do |key, value|
      next if key == 'options'
      send(key.to_sym, value)
    end
  else
    current_value_does_not_exist!
  end
end

action_class do
  include Flatpak::Cookbook::Helpers
end

action :add do
  converge_if_changed do
    remotes = flatpak_get_remotes

    cmd = [
      'flatpak',
      # (new_resource.user ? '--user' : '--system'),
      # modify existing remote, or create
      (remotes.key?(new_resource.remote_name) ? 'remote-modify' : 'remote-add'),
      # flatpak remote-add NAME LOCATION --OPTIONS
      new_resource.remote_name,
      new_resource.location,
      ("--prio='#{new_resource.priority}'" if new_resource.priority),
      ("--title='#{new_resource.title}'" if new_resource.title),
      ("--comment='#{new_resource.comment}'" if new_resource.comment),
      ("--description='#{new_resource.description}'" if new_resource.description),
      ("--homepage='#{new_resource.homepage}'" if new_resource.homepage),
      ("--icon='#{new_resource.icon}'" if new_resource.icon),
      ("--subset='#{new_resource.subset}'" if new_resource.subset),
      # ("--filter='#{new_resource.filter}'" if !new_resource.filter.empty?),
      *new_resource.flags, # any additional user-supplied ones
    ].join(' ')

    shell_out!(cmd)
  end
end

action :remove do
end
