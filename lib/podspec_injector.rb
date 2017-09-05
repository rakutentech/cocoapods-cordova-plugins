require 'cordova_project/cordova_project'

module CocoaPodsCordovaPlugins
    class PodspecInjector
        def initialize(project_podfile)
            raise ArgumentError, 'Missing source project podfile' unless project_podfile

            @project_podfile = project_podfile
        end

        def inject_temp_podspec(temp_podspec_path)
            @project_podfile.pod 'CordovaPlugins', :path => temp_podspec_path
        end

        def inject_pods_sources(cordova_project)
            cordova_project.podfile.pods_sources.each do |source|
                @project_podfile.source source
            end
        end
    end
end
