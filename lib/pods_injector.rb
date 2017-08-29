require 'cocoapods-core'
require 'cordova_project/cordova_project'

module CocoaPodsCordovaPlugins
    class PodsInjector
        def initialize(project_podfile)
            raise ArgumentError 'Project podfile missing' unless project_podfile

            @project_podfile = project_podfile
        end

        def inject(cordova_project)
            cordova_podfile = Pod::Podfile.from_file(cordova_project.podfile_path)

            puts 'Before:'
            puts @project_podfile.to_hash

            cordova_podfile.target_definitions.each do |name, target|
                target.dependencies.each do |dependency|
                    @project_podfile.root_target_definitions.each do |root_target_definition|
                        root_target_definition.store_pod(dependency.name, dependency.requirement)
                    end
                end
            end

            puts 'After:'
            puts @project_podfile.to_hash
        end
    end
end
