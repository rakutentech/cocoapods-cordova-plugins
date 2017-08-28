require 'cocoapods-core'
require 'fs_helper'
require 'cordova_project/cordova_project'
require 'pods_injector'

BUILD_DIR = '.build'

module CocoaPodsCordovaPlugins
    class << self
        Pod::HooksManager.register('cocoapods-cordova-plugins', :pre_install) do |context, options|
            CocoaPodsCordovaPlugins.on_pre_install(context.podfile, options)
        end

        def on_pre_install(podfile, options)
            fs_helper = CocoaPodsCordovaPlugins::FSHelper
            cordova_project = CocoaPodsCordovaPlugins::CordovaProject.new(options, File.join(Dir.pwd, BUILD_DIR))
            deps_injector = CocoaPodsCordovaPlugins::PodsInjector.new(podfile)

            unless cordova_project.isCordovaInstalled
                raise Pod::Informative, 'Cordova is missing on the machine. Please install cordova via `npm i -g cordova`'
            end

            fs_helper.recreate_dir BUILD_DIR
            fs_helper.cd BUILD_DIR

            cordova_project.create
            deps_injector.inject(cordova_project.podfile_path)

            fs_helper.cd '..'
        end
    end
end
