module Flatpak
  module Cookbook
    module Helpers
      def flatpak_version
        # we can discard the patch version here
        # the checks we need are just major.minor for features
        # the main problem distros here are centos 7, debian 10, and amazon 2

        # we can save this as it wont change during the chef run
        @version ||= shell_out!('flatpak --version').stdout.delete_prefix('Flatpak ').to_f
      end

      def flatpak_current_remotes
        if flatpak_version >= 1.1 # for --columns
          shell_out!('flatpak remotes --columns name').stdout.split
        else
          shell_out!('flatpak remotes').stdout.split("\n").map { |r| r.split.first }
        end
      end

      def flatpak_current_apps
        if flatpak_version >= 1.1 # for --columns
          shell_out!('flatpak list --columns application,ref').stdout.split
        else
          shell_out!('flatpak list').stdout.split("\n").map { |r| r.split[-5] }
        end
      end

      def noninteractive
        '--noninteractive' if flatpak_version >= 1.2
      end
    end
  end
end
