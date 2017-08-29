require 'cocoapods-core'
require 'fs_helper'
require 'cordova_project/project_creator'
require 'pods_injector'
require 'utils'

BUILD_DIR = '.build'

module CocoaPodsCordovaPlugins
    class << self
        Pod::HooksManager.register('cocoapods-cordova-plugins', :pre_install) do |context, options|
            CocoaPodsCordovaPlugins.on_pre_install(context.podfile, options)
        end

        def on_pre_install(podfile, options)
            unless CocoaPodsCordovaPlugins.is_cordova_installed
                raise Pod::Informative, 'Cordova is missing on the machine. Please install cordova via `npm i -g cordova`'
            end

            build_dir = File.join(Dir.pwd, BUILD_DIR)
            CocoaPodsCordovaPlugins::FSHelper.recreate_dir build_dir

            project_creator = CocoaPodsCordovaPlugins::ProjectCreator.new(options, build_dir)
            cordova_project = project_creator.create

            pods_injector = CocoaPodsCordovaPlugins::PodsInjector.new(podfile)
            pods_injector.inject cordova_project
        end
    end
end
