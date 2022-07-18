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

      def flatpak_supports_columns?
        flatpak_version >= 1.1
      end

      def flatpak_supports_filters?
        flatpak_version >= 1.3  # 1.3.4
      end

      def flatpak_current_remotes
        if flatpak_supports_columns?
          shell_out!('flatpak remotes --columns name').stdout.split
        else
          shell_out!('flatpak remotes').stdout.split("\n").map { |r| r.split("\t").first }
        end
      end

      def flatpak_current_priorities
        if flatpak_supports_columns?
          shell_out!('flatpak remotes --columns name,priority').stdout.split("\n").map(&:split).to_h
        else
          shell_out!('flatpak remotes -d').stdout.split("\n").map do |r|
            remote = r.split("\t")
            [remote[0], remote[-1]]
          end.to_h
        end
      end

      def flatpak_installed_apps
        if flatpak_supports_columns?
          shell_out!('flatpak list --columns application,ref').stdout.split
        else
          shell_out!('flatpak list').stdout.split("\n").map do |r|
            ref = r.split("\t").first # list on this version only returns the full ref
            [ref, ref.split('/').first] # so extract just the.application.id from it
          end.flatten
        end
      end

      def flatpak_updateable_apps
        if flatpak_supports_columns?
          shell_out!('flatpak list --updates --columns application,ref').stdout.split
        else
          shell_out!('flatpak list --updates').stdout.split("\n").map do |r|
            ref = r.split("\t").first # list on this version only returns the full ref
            [ref, ref.split('/').first] # so extract just the.application.id from it
          end.flatten
        end
      end

      def noninteractive
        '--noninteractive' if flatpak_version >= 1.2
      end
    end
  end
end
