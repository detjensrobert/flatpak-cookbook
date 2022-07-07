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

  describe ini('/etc/flatpak/remotes.d/fedora.flatpakrepo') do
    it { should exist }
    its(['Flatpak Repo', 'Url']) { should eq 'oci+https://registry.fedoraproject.org' }
  end

  describe command('flatpak remotes --columns name') do
    its('stdout') { should match /fedora/ }
  end

  describe command('flatpak remote-ls --columns application') do
    its('stdout') { should match /org.fedoraproject.MediaWriter/ }
    # recipe confgures remote to only show org.fedoraproject.*
    its('stdout') { should_not match /org.mozilla.Firefox/ }
  end
end
