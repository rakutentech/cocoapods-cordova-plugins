require 'fileutils'

module CocoaPodsCordovaPlugins
    module FSHelper
        class << self
            def cd(path)
                FileUtils.chdir(path)
            end

            def recreate_dir(dir)
                FileUtils.rm_r(dir, :force => true)
                FileUtils.mkpath(dir)
            end

            def list_dirs(dir)
                dirnames = Dir.entries(dir).select {|entry| File.directory? File.join(dir, entry) and !(entry =='.' || entry == '..')}

                dirnames.map {|entry| File.join(dir, entry)}
            end

            def list_files(dir, pattern)
                files =  Dir.entries(dir).select { |entry| File.file? File.join(dir, entry) and pattern.match(entry) }

                files.map {|entry| File.join(dir, entry)}
            end
        end
    end
end
