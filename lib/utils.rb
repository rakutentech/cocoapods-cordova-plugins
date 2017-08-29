module CocoaPodsCordovaPlugins
    class << self
        def is_cordova_installed
            return Kernel.system('cordova', '--version')
        end
    end
end
