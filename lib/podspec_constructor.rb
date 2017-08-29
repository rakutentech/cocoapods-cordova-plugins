require 'fs_helper'

PODSPEC_DIR = 'temp_podspec'

module CocoaPodsCordovaPlugins
    class PodspecConstructor
        def initialize(cordova_project, build_dir)
            raise ArgumentError, 'Missing cordova project' unless cordova_project
            raise ArgumentError, 'Missing build directory' unless build_dir

            @project = cordova_project
            @build_dir = build_dir
        end

        def construct_podspec

        end
    end
end
