flatpak_install 'test' do
  configure_flathub false
end

flatpak_remote 'fedora' do
  location 'oci+https://registry.fedoraproject.org'
end
