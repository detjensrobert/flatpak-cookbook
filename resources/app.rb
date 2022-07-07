provides :flatpak_app
unified_mode true

property :ref, String, name_property: true,
          description: 'Full ref of the application/runtime to install, possibly including arch/branch'

property :remote, String,
          description: 'Remote to install the application from'

property :flags, Array, default: [],
          coerce: proc { |p| p.sort },
          description: 'Additional CLI flags to specify when installing'

action_class do
  def get_installed_flatpaks
    shell_out!('flatpak list --columns application,ref').stdout.split
  end
end

action :install do
  unless get_installed_flatpaks.include? new_resource.ref
    converge_by "install #{new_resource.ref}#{(' from remote ' + new_resource.remote) if new_resource.remote}" do
      cmd = [
        'flatpak install --noninteractive --assumeyes',
        new_resource.remote,
        new_resource.ref,
        *new_resource.flags,
      ].join(' ')

      shell_out!(cmd)
    end
  end
end
