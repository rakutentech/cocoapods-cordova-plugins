require 'cordova_project/project_creator'
require 'fs_helper'

CORDOVA_PROJECT_DIR = 'cordova_proj'

module CocoaPodsCordovaPlugins
    class CordovaProject
        def initialize(config, build_dir_path)
            raise ArgumentError, 'Missing config' unless config
            raise ArgumentError, 'Missing build dir path' unless build_dir_path

            @project_creator = CocoaPodsCordovaPlugins::ProjectCreator.new(config, CORDOVA_PROJECT_DIR)
            @build_dir_path = build_dir_path
        end

        def isCordovaInstalled
            return Kernel.system('cordova', '--version')
        end

        def create
            @project_creator.create
        end

        def podfile_path
            return File.join(@build_dir_path, CORDOVA_PROJECT_DIR, 'platforms', 'ios', 'Podfile')
        end

        def list_native_sources
            path_to_plugins = File.join(@build_dir_path,
                CORDOVA_PROJECT_DIR,
                'platforms',
                'ios',
                'HelloCordova',
                'Plugins'
            )

            plugins_dirs = CocoaPodsCordovaPlugins::FSHelper.list_dirs(path_to_plugins)

            plugins_dirs.map do |plugin_dir|
                CocoaPodsCordovaPlugins::FSHelper.list_files(plugin_dir, /.h|.m|.swift$/)
            end.flatten
        end

        def list_framewords
        end
    end
end
