provides :flatpak_remote
unified_mode true

property :remote_name, String, name_property: true,
          description: 'Name of the remote to configure'

# Either .location OR .url, etc are required
# .location is the url from `flatpak install URL`
# and contains all the other stuff

property :location, String

property :url, String
property :title, String
property :comment, String
property :description, String
property :homepage, String
property :icon, String
property :gpgkey, String
property :gpg_verify, [true, false], default: true
property :collection_id, String
# (location file )

# property :filter, Array, default: [],
#           description: 'List of filters to apply, see flatpak-remote-add docs'

property :priority, Integer,
          coerce: proc { |p| p.to_i },
          description: 'Priority for the configured remote, higher will be chosen first'

property :subset, String

action_class do
  include Flatpak::Cookbook::Helpers
end

action :add do
  # validate either required property is met
  unless new_resource.location || new_resource.url
    raise "The #{new_resource.remote_name} `flatpak_remote` resource must have either .location or .url specified!"
  end

  directory '/etc/flatpak/remotes.d' do
    recursive true
  end

  if new_resource.location
    remote_file "/etc/flatpak/remotes.d/#{new_resource.remote_name}.flatpakrepo" do
      source new_resource.location
    end
  else
    template "/etc/flatpak/remotes.d/#{new_resource.remote_name}.flatpakrepo" do
      source 'remote.flatpakrepo.erb'
      cookbook 'flatpak'
      variables(
        name: new_resource.remote_name,
        url: new_resource.url,
        priority: new_resource.priority,
        title: new_resource.title,
        comment: new_resource.comment,
        description: new_resource.description,
        homepage: new_resource.homepage,
        icon: new_resource.icon,
        collection_id: new_resource.collection_id
      )
    end
  end
end

action :remove do
  file "/etc/flatpak/remotes.d/#{new_resource.remote_name}.flatpakrepo" do
    action :delete
  end
end
