require 'fileutils'

module CocoaPodsCordovaPlugins
    class ProjectCreator
        def initialize(config)
            raise ArgumentError, 'Missing config' unless config
            raise ArgumentError, 'Missing plugins declaration' unless config[:plugins]

            @config = config
        end

        def isCordovaInstalled
            return Kernel.system('cordova', '--version')
        end

        def create
            recreate_temp_dir

            FileUtils.chdir('./tmp_build')

            create_cordova_project
            add_ios_platform
            add_plugins
            prepare_cordova_project

            FileUtils.chdir('..')
        end

        private
        def recreate_temp_dir
            FileUtils.rm_r('./tmp_build', :force => true)
            FileUtils.mkpath('./tmp_build')
        end

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
