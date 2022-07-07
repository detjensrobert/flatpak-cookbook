name              'flatpak'
maintainer        'Robert Detjens'
maintainer_email  'chef@detjens.dev'
license           'MIT'
description       'Installs/Configures flatpak'
version           '0.1.0'
chef_version      '>= 16.0'

issues_url 'https://github.com/detjensrobert/flatpak-cookbook/issues'
source_url 'https://github.com/detjensrobert/flatpak-cookbook'

supports 'amazon', '>= 2.0'
supports 'centos', '>= 7.0'
supports 'debian', '>= 11.0' # TODO: support older flatpak for d10
supports 'redhat', '>= 7.0'
supports 'ubuntu', '>= 18.04'
supports 'fedora', '>= 33.0'
