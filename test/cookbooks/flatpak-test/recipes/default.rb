flatpak_install 'test'

flatpak_app 'org.clementine_player.Clementine' do
  # centos 7 and amazon always need the remote specified
  # this is optional on newer flatpak versions
  remote 'flathub'
end
