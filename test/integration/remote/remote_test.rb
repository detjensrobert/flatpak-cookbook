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
  title 'Flatpak remotes are configured correctly'

  describe file('/etc/flatpak/remotes.d/fedora.flatpakrepo') do
    it { should exist }
    its('content') { should match Regexp.escape('Url=oci+https://registry.fedoraproject.org') }
  end

  describe file('/etc/flatpak/remotes.d/fedora.filter') do
    it { should exist }
    its('content') { should match /deny \*/ }
    its('content') { should match /allow org.fedoraproject.\*/ }
  end

  describe file('/etc/flatpak/remotes.d/gnome-nightly.flatpakrepo') do
    it { should_not exist }
  end

  # describe command('flatpak remotes --columns name') do
  describe command('flatpak remotes') do
    its('stdout') { should match /fedora/ }
    its('stdout') { should_not match /gnome-nightly/ }
  end
end

control 'filter' do
  title 'Verify remote filter is honored correctly'
  only_if 'remote filtering not supported by old flatpak' do
    # only newer flatpak supports filters
    !((os.redhat? && os.release.to_i == 7) || os.name == 'amazon' || (os.debian? && os.release.to_i == 10))
    # command('flatpak --version').stdout.delete_prefix('Flatpak ').to_f >= 1.3
  end

  # recipe confgures remote to only show org.fedoraproject.*
  # describe command('flatpak remote-ls fedora --columns application') do
  describe command('flatpak remote-ls fedora') do
    its('stdout') { should match /org.fedoraproject.MediaWriter/ }
    its('stdout') { should_not match /org.gnome/ }
  end
end
