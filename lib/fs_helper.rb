require 'fileutils'

module CocoaPodsCordovaPlugins
    module FSHelper
        class << self
            def recreate_dir(dir)
                FileUtils.rm_r(dir, :force => true)
                FileUtils.mkpath(dir)
            end

            def list_dirs(dir, pattern = //)
                list_entries(dir, :directory?, pattern)
            end

            def list_files(dir, pattern = //)
                list_entries(dir, :file?, pattern)
            end

            private
            def list_entries(dir, selector, pattern)
                entries = Dir.entries(dir).select do |entry|
                    File.send(selector, File.join(dir, entry)) and pattern.match(entry) and !(entry == '.' || entry == '..')
                end

                entries.map {|entry| File.join(dir, entry)}
            end
        end
    end
end
