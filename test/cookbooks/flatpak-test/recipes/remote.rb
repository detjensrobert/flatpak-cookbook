flatpak_install 'test' do
  configure_flathub false
end

flatpak_remote 'fedora' do
  url 'oci+https://registry.fedoraproject.org'
  title 'Fedora'
  comment 'Fedora Flatpaks'
  subset 'org.fedoraproject.*'
end
