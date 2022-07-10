flatpak_install 'test' do
  configure_flathub false
end

flatpak_remote 'fedora' do
  url 'oci+https://registry.fedoraproject.org'
  title 'Fedora'
  comment 'Fedora Flatpaks'
  filters [
    'deny *',
    'allow org.fedoraproject.*',
  ]
end

flatpak_remote 'gnome-nightly' do
  location 'https://nightly.gnome.org/gnome-nightly.flatpakrepo'
end

flatpak_remote 'gnome-nightly' do
  action :remove
end
