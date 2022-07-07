provides :flatpak_install
unified_mode true

property :configure_flathub, [true, false], default: true,
          description: 'Add the flathub remote automatically '

action :install do
  # upstream recommends their PPA for older ubuntu versions (older than 22.04)
  if platform?('ubuntu') && node['platform_version'].to_f < 22.04
    apt_repository 'flatpak' do
      uri 'ppa:flatpak/stable'
    end
  end

  package 'flatpak'

  if new_resource.configure_flathub
    flatpak_remote 'flathub' do
      location 'https://flathub.org/repo/flathub.flatpakrepo'
    end
  end
end
