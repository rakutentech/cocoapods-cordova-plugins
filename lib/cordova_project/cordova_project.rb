require 'fs_helper'
require 'podfile_parser'

module CocoaPodsCordovaPlugins
    class CordovaProject
        def initialize(cordova_project_dir)
            raise ArgumentError, 'Missing build dir path' unless cordova_project_dir

            @cordova_project_dir = cordova_project_dir
        end

        def podfile
            return CocoaPodsCordovaPlugins::PodfileParser.new(File.join(@cordova_project_dir, 'platforms', 'ios', 'Podfile'))
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

        end

        def list_frameworks
            []
        end
    end
end
