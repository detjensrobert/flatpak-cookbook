provides :flatpak_app
unified_mode true

property :ref, String, name_property: true,
          description: 'Full ref of the application/runtime to install, possibly including arch/branch'

property :remote, String,
          description: 'Remote to install the application from'

property :flags, Array, default: [],
          coerce: proc { |p| p.sort },
          description: 'Additional CLI flags to specify when installing / updating'

action_class do
  include Flatpak::Cookbook::Helpers
end

action :install do
  unless flatpak_current_apps.include? new_resource.ref
    converge_by "install #{new_resource.ref}#{(' from remote ' + new_resource.remote) if new_resource.remote}" do
      cmd = [
        "flatpak install #{noninteractive} --assumeyes",
        new_resource.remote,
        new_resource.ref,
        *new_resource.flags,
      ].join(' ')

      shell_out!(cmd, timeout: 3600)
    end
  end
end

action :update do
  if flatpak_current_apps.include? new_resource.ref
    converge_by "update #{new_resource.ref}" do
      cmd = [
        "flatpak update #{noninteractive} --assumeyes",
        new_resource.ref,
        *new_resource.flags,
      ].join(' ')

      shell_out!(cmd, timeout: 3600)
    end
  end
end

action :remove do
  if flatpak_current_apps.include? new_resource.ref
    converge_by "remove #{new_resource.ref}" do
      cmd = [
        "flatpak remove #{noninteractive} --assumeyes",
        new_resource.ref,
        *new_resource.flags,
      ].join(' ')

      shell_out!(cmd, timeout: 3600)
    end
  end
end
