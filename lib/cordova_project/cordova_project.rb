require 'fs_helper'
require 'podfile_parser'
require 'xcodeproj'

module CocoaPodsCordovaPlugins
    class CordovaProject
        def initialize(cordova_project_dir)
            raise ArgumentError, 'Missing build dir path' unless cordova_project_dir

            @cordova_project_dir = cordova_project_dir
        end

        def podfile
            return CocoaPodsCordovaPlugins::PodfileParser.new(File.join(@cordova_project_dir, 'platforms', 'ios', 'Podfile'))
        end

        def cordova_config_file
            return File.join(@cordova_project_dir, 'platforms', 'ios', 'HelloCordova', 'config.xml')
        end

        def list_native_sources
            path_to_plugins = File.join(
                @cordova_project_dir,
                'platforms',
                'ios',
                'HelloCordova', # default name of generated iOS project
                'Plugins'
            )

            plugins_dirs = CocoaPodsCordovaPlugins::FSHelper.list_dirs(path_to_plugins)

            plugins_dirs.map do |plugin_dir|
                CocoaPodsCordovaPlugins::FSHelper.list_files(plugin_dir, /.h|.m|.swift$/)
            end.flatten
        end

        def list_js_sources
            js_sources_path = File.join(@cordova_project_dir, 'platforms', 'ios', 'www')

            return [
                CocoaPodsCordovaPlugins::FSHelper.list_files(js_sources_path, /.js$/),
                File.join(js_sources_path, 'plugins'),
                File.join(js_sources_path, 'cordova-js-src')
            ].flatten
        end

        def list_resources
            resources_path = File.join(@cordova_project_dir, 'platforms', 'ios', 'HelloCordova', 'Resources')

            return CocoaPodsCordovaPlugins::FSHelper.list_files(resources_path)
        end

        def list_frameworks
            result = []
            project = Xcodeproj::Project.open(File.join(@cordova_project_dir, 'platforms', 'ios', 'HelloCordova.xcodeproj'))

            project.native_targets.each do |target|
                target.frameworks_build_phase.files.each do |file|
                    framework = file.file_ref.name
                    result << framework if framework
                end
            end

            return result.uniq.map {|entry| entry.gsub('.framework', '')}
        end
    end
end
