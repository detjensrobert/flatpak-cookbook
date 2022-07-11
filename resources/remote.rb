provides :flatpak_remote
unified_mode true

property :remote_name, String, name_property: true,
          description: 'Name of the remote to configure'

# Either .location OR .url, etc are required
# .location is the url from `flatpak install URL`
# and contains all the other stuff
property :location, String,
          regex: /.+\.flatpakrepo/

property :url, String
property :title, String
property :comment, String
property :description, String
property :homepage, String
property :icon, String
property :gpgkey, String
property :collection_id, String

property :filters, Array,
          description: 'List of filters to apply, see flatpak-remote-add docs'

property :priority, Integer,
          coerce: proc { |p| p.to_i },
          description: 'Priority for the configured remote, higher will be chosen first'

action_class do
  include Flatpak::Cookbook::Helpers
end

action :add do
  # validate either of the required properties are set
  unless new_resource.location || new_resource.url
    raise "The #{new_resource.remote_name} `flatpak_remote` resource must have either .location or .url specified!"
  end
  # warn if both are set
  if new_resource.location && new_resource.url
    warn 'Preferring .location over manual .url, did you mean to set both?'
  end

  directory '/etc/flatpak/remotes.d' do
    recursive true
  end

  filter_file = nil
  if new_resource.filters
    filter_file = "/etc/flatpak/remotes.d/#{new_resource.remote_name}.filter"
    template filter_file do
      source 'remote.filter.erb'
      cookbook 'flatpak'
      variables(filters: new_resource.filters)
    end
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
        title: new_resource.title,
        comment: new_resource.comment,
        description: new_resource.description,
        homepage: new_resource.homepage,
        icon: new_resource.icon,
        gpgkey: new_resource.gpgkey,
        collection_id: new_resource.collection_id,
        filter_file: filter_file
      )
    end
  end

  # older versions of flatpak don't pick up flatpakrepo files in remotes.d
  # gotta tell it to import the remote manually
  unless flatpak_current_remotes.include?(new_resource.remote_name)
    converge_by "import /etc/flatpak/remotes.d/#{new_resource.remote_name}.flatpakrepo" do
      shell_out!("flatpak remote-add #{new_resource.remote_name} /etc/flatpak/remotes.d/#{new_resource.remote_name}.flatpakrepo")
    end
  end

  if new_resource.priority
    current_priorities = shell_out!('flatpak remotes --columns name,priority').stdout.split("\n").map(&:split).to_h

    if current_priorities[new_resource.remote_name].to_i != new_resource.priority.to_i
      converge_by "set priority for #{new_resource.remote_name}" do
        shell_out!("flatpak remote-modify #{new_resource.remote_name} --prio=#{new_resource.priority}")
      end
    end
  end
end

action :remove do
  file "/etc/flatpak/remotes.d/#{new_resource.remote_name}.flatpakrepo" do
    action :delete
  end

  file "/etc/flatpak/remotes.d/#{new_resource.remote_name}.filter" do
    action :delete
  end

  # older versions of flatpak don't update when the .flatpakrepo is deleted
  # gotta tell it to delete the remote manually
  if flatpak_current_remotes.include?(new_resource.remote_name)
    converge_by "remove #{new_resource.remote_name}" do
      shell_out!("flatpak remote-delete #{new_resource.remote_name}")
    end
  end
end
