control 'flatpak' do
  title 'Flatpak package is installed'

  describe package('flatpak') do
    it { should be_installed }
  end

  describe command('flatpak --version') do
    its('stdout') { should match /Flatpak 1\.\d+\.\d+/ }
  end
end

control 'remote' do
  title 'Flatpak remote is configured'

  describe ini('/etc/flatpak/remotes.d/flathub.flatpakrepo') do
    its(['Flatpak Repo', 'Url']) { should eq 'https://dl.flathub.org/repo/' }
  end

  # describe command('flatpak remotes --columns name') do
  describe command('flatpak remotes') do
    its('stdout') { should match /flathub/ }
  end

  # describe command('flatpak remote-ls --columns application') do
  describe command('flatpak remote-ls') do
    its('stdout') { should match /org.mozilla.firefox/ }
    its('stdout') { should match /com.valvesoftware.Steam/ }
  end
end

control 'app' do
  title 'Flatpak apps are installed'

  # describe command('flatpak list --columns application') do
  describe command('flatpak list') do
    its('stdout') { should match /org.clementine_player.Clementine/ }
  end
end
