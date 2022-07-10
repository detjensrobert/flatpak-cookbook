control 'flatpak' do
  title 'Flatpak package is installed'

  describe package('flatpak') do
    it { should be_installed }
  end

  describe command('flatpak --version') do
    its('stdout') { should match /Flatpak 1\.\d+\.\d+/ }
  end
end

control 'app' do
  title 'Flatpak apps are installed'

  describe command('flatpak list --columns application,origin') do
    its('stdout') { should match /org.gnome.Music\s+flathub/ }
    its('stdout') { should match /org.gnome.Calculator\s+fedora/ }
  end
end
