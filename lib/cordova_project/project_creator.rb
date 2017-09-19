require 'fs_helper'
require 'cordova_project/cordova_project'

CORDOVA_PROJECT_DIR = 'cordova_proj'

module CocoaPodsCordovaPlugins
    class ProjectCreator
        def initialize(config, build_dir)
            raise ArgumentError, 'Missing config' unless config
            raise ArgumentError, 'Missing plugins declaration' unless config[:plugins]
            raise ArgumentError, 'Missing build dir' unless build_dir

            @config = config
            @build_dir = build_dir

            @fs_helper = CocoaPodsCordovaPlugins::FSHelper
        end

        def create
            build_path = File.join(@build_dir, CORDOVA_PROJECT_DIR)
            @fs_helper.recreate_dir(build_path)

            Dir.chdir(build_path) do
                create_cordova_project
                add_ios_platform
                configure_plugins_registry
                add_plugins
                prepare_cordova_project
            end

            return CocoaPodsCordovaPlugins::CordovaProject.new(build_path)
        end

        private
        def create_cordova_project
            Kernel.system('cordova', 'create', '.')
        end


        def add_ios_platform
            Kernel.system('cordova', 'platform', 'add', 'ios')
        end

        def configure_plugins_registry
            File.open('.npmrc', 'w') {|f| f.write("registry=#{@config[:registry]}")} if @config[:registry]
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

            return command + ' --save'
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
