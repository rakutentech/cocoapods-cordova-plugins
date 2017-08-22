module CocoaPodsCordovaPlugins
    class ProjectCreator
        def initialize(config)
            @config = config
        end

        def create
            unless self.isCordovaInstalled
                puts 'Cordova is missing on the machine. Please install cordova via `npm i -g cordova`';
                exit(1);
            end
        end

        def isCordovaInstalled
            return Kernel.system('cordova --version')
        end
    end
end
