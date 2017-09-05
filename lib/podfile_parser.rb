require 'cocoapods-core'
require 'cordova_project/cordova_project'

module CocoaPodsCordovaPlugins
    class PodfileParser
        def initialize(podfile_path)
            raise ArgumentError 'Podfile path missing' unless podfile_path

            @podfile = Pod::Podfile.from_file(podfile_path)
        end

        def pods_sources
            return @podfile.sources
        end

        def pods
            pods = []

            @podfile.target_definitions.each do |name, target|
                target.dependencies.each do |dependency|
                    pods.push({:name => dependency.name, :requirement => dependency.requirement.to_s})
                end
            end

            return pods
        end
    end
end
