module Flatpak
  module Cookbook
    module Helpers
      def flatpak_repo_options_to_flags(option)
        {
          'no-gpg-verify' => '--no-gpg-verify',
          'no-enumerate' => '--no-enumerate',
          'disabled' => '--disable',
          # covered by .user property
          # 'user' => '--user',
          # 'system' => '--system',
        }[option]
      end

      # this is ugly since the flatpak command doesnt really emit machine readable output
      # returns hash of { remote_name => {options}, ... }
      def flatpak_get_remotes_cli
        columns = %w(name title url priority comment description homepage icon subset options)
        remotes_raw = shell_out!("flatpak remotes --columns #{columns.join(',')}").stdout.split("\n")

        # dont do any parsing if theres no remotes
        return {} if remotes_raw.empty?

        # create hash of columns from output
        remotes = remotes_raw.map do |row|
          # output fields delineated by tabs, empty values from flatpak are "-", replace them with nil
          values = row.split("\t").map { |v| v == '-' ? nil : v }
          val_h = columns.zip(values).to_h # convert column values array to hash

          # [hash, hash, ...] -> {name => hash, ...}
          [val_h['name'], val_h]
        end.to_h

        # coerce some options to what the resource properties expect
        remotes.each do |_name, r|
          r['options'] ||= ''
          r['options'] = r['options'].split(',')
          r['user'] = r['options'].include?('user')
          r['flags'] = r['options'].map { |o| flatpak_repo_options_to_flags(o) }.compact
        end
      end
    end
  end
end
