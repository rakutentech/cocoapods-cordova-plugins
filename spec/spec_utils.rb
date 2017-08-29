require 'fileutils'

module SpecUtils
    def mk_dir_tree(structure, root = '/')
        entries = structure.keys

        entries.each do |entry|
            content = structure[entry]
            path = File.join(root, entry.to_s)

            if content.is_a? Hash then
                FileUtils.mkdir_p path

                mk_dir_tree(content, path)
            else
                file = File.open(path, 'w')
                file << content
                file.close
            end
        end
    end
end
