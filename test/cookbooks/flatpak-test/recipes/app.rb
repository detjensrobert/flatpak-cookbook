include_recipe 'flatpak-test::dokken-xvfb'

flatpak_install 'test'

flatpak_remote 'fedora' do
  url 'oci+https://registry.fedoraproject.org'
  priority 10
end

# test installing apps from different remotes
# should install from `fedora` as it has higher priority
# flatpak_app 'org.gnome.Maps'

flatpak_app 'org.gnome.Music' do
  remote 'flathub'
end

flatpak_app 'org.gnome.Calculator' do
  remote 'fedora'
end
