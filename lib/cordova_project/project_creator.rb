require 'fs_helper'

module CocoaPodsCordovaPlugins
    class ProjectCreator
        def initialize(config, project_dir)
            raise ArgumentError, 'Missing config' unless config
            raise ArgumentError, 'Missing plugins declaration' unless config[:plugins]
            raise ArgumentError, 'Missing project dir' unless project_dir

            @config = config
            @project_dir = project_dir

            @fs_helper = CocoaPodsCordovaPlugins::FSHelper
        end

        def create
            @fs_helper.recreate_dir(@project_dir)
            @fs_helper.cd(@project_dir)

            create_cordova_project
            add_ios_platform
            add_plugins
            prepare_cordova_project

            @fs_helper.cd('..')
        end

        private
        def create_cordova_project
            Kernel.system('cordova', 'create', '.')
        end


        def add_ios_platform
            Kernel.system('cordova', 'platform', 'add', 'ios')
        end

        def add_plugins
            @config[:plugins].each do |plugin|
                command = build_add_plugin_command(plugin)

                Kernel.system(command)
            end
        end

        def build_add_plugin_command(pluginDesc)
            name = pluginDesc[:name]
            version = pluginDesc[:version]
            params = pluginDesc[:params]

            command = "cordova plugin add #{name}"
            command += '@' + version if version
            command += ' ' + build_plugin_params(params) if params

            return command
        end

        def build_plugin_params(pluginParams)
            return pluginParams.map do |key, value|
                "--variable #{key}=#{value}"
            end.join(' ')
        end

        def prepare_cordova_project
            Kernel.system('cordova', 'prepare')
        end
    end
end
