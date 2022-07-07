control 'flatpak' do
  title 'flatpak package is installed'

  describe package('flatpak') do
    it { should be_installed }
  end

  describe command('flatpak --version') do
    its('stdout') { should match /Flatpak 1\.\d+\.\d+/ }
  end
end

control 'remote' do
  title 'flatpak remote is configured'

  describe ini('/etc/flatpak/remotes.d/flathub.flatpakrepo') do
    its(['Flatpak Repo', 'Url']) { should eq 'https://dl.flathub.org/repo/' }
  end

  describe command('flatpak remotes --columns name') do
    its('stdout') { should match /flathub/ }
  end

  describe command('flatpak remote-ls --columns application') do
    its('stdout') { should match /org.mozilla.firefox/ }
    its('stdout') { should match /com.valvesoftware.Steam/ }
  end
end
