require 'cocoapods-core'
require 'fs_helper'
require 'cordova_project/project_creator'
require 'podspec_injector'
require 'pod_constructor'
require 'utils'
require 'xcodeproj'

BUILD_DIR = '.build'

module CocoaPodsCordovaPlugins
    class << self
        Pod::HooksManager.register('cocoapods-cordova-plugins', :pre_install) do |context, options|
            CocoaPodsCordovaPlugins.on_pre_install(context.podfile, options)
        end

        Pod::HooksManager.register('cocoapods-cordova-plugins', :post_install) do |context, options|
            CocoaPodsCordovaPlugins.on_post_install(context, options)

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

        def on_post_install(context, options)
            # puts context.umbrella_targets
            # puts context.umbrella_targets[0].user_project.to_s
        # class - PBXNativeTarget
            # puts context.umbrella_targets[0].user_targets[0].build_phases

            context.umbrella_targets.each do |umbrella|
                project = umbrella.user_project
                script_phase_class = Xcodeproj::Project::Object::PBXShellScriptBuildPhase

                umbrella.user_targets.each do |target|
                    phase_name = '[CocoaPods plugins] Copy JS sources'
                    existing_phase = target.build_phases.select {|ph| ph.is_a?(script_phase_class)}.find {|ph| ph.name.end_with?(phase_name)}
                    phase = existing_phase || project.new(script_phase_class)

                    phase.name = phase_name
                    phase.shell_script = 'cp -r $TARGET_BUILD_DIR/$TARGET_NAME.app/Frameworks/CordovaPlugins.framework/www $TARGET_BUILD_DIR/$TARGET_NAME.app/www'

                    target.build_phases << phase unless target.build_phases.include? phase
                end

                project.save
            end

        end
    end
end
