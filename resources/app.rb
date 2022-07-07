provides :flatpak_app
unified_mode true

property :ref, String, name_property: true,
          description: 'Full ref of the application/runtime to install'

property :remote, String,
          description: 'Remote to install the application from'

property :flags, Array, default: [],
          coerce: proc { |p| p.sort },
          description: 'Additional CLI flags to specify when installing'

action :install do
  cmd = [
    'flatpak install --noninteractive --assumeyes',
    new_resource.remote,
    new_resource.ref,
    *new_resource.flags,
  ].join(' ')

  shell_out!(cmd)
end
