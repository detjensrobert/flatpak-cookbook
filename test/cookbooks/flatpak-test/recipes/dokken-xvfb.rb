# installing apps from fedora flatpak repo needs D-Bus, D-Bus autostart needs X
# dokken containers don't start X like a VM does
# so, install and start a headless X server instead
if node['hostname'] == 'dokken'
  case node['platform_family']
  when 'rhel', 'fedora', 'amazon'
    package %w(xorg-x11-server-Xvfb dbus-x11)
  when 'debian'
    package %w(xvfb dbus-x11)
  end

  systemd_unit 'x11-xvfb.service' do
    content <<~UNIT
      [Unit]
      Description=Xvfb Virtual X Server

      [Service]
      ExecStart=/usr/bin/Xvfb :99 -screen 0 1920x1080x24

      [Install]
      WantedBy=multi-user.target
    UNIT
    action [:create, :start]
  end

  # update env
  ENV['DISPLAY'] = ':99'
end
