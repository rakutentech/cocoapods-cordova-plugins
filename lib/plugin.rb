require 'cocoapods-core'
require 'fs_helper'
require 'cordova_project/project_creator'
require 'podspec_injector'
require 'pod_constructor'
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

            # build_dir = '/Users/ilia.isupov/Documents/prototypes/cocoapods-cordova-plugins/.build'
            # cordova_project = CocoaPodsCordovaPlugins::CordovaProject.new('/Users/ilia.isupov/Documents/prototypes/cocoapods-cordova-plugins/.build/cordova_proj')

            podspec_constructor = CocoaPodsCordovaPlugins::PodConstructor.new(cordova_project, build_dir)
            temp_podspec_path = podspec_constructor.construct_pod

            pods_injector = CocoaPodsCordovaPlugins::PodspecInjector.new(podfile)
            pods_injector.inject_pods_sources cordova_project
            pods_injector.inject_temp_podspec temp_podspec_path
        end
    end
end
