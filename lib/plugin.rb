require 'cocoapods-core'
require 'project_creator'

module CocoaPodsCordovaPlugins
    class << self
        Pod::HooksManager.register('cocoapods-cordova-plugins', :pre_install) do |context, options|
            CocoaPodsCordovaPlugins.on_pre_install(context.podfile, options)
        end

        def on_pre_install(podfile, options)
            project_creator = CocoaPodsCordovaPlugins::ProjectCreator.new(options)

            unless project_creator.isCordovaInstalled
                raise Pod::Informative, 'Cordova is missing on the machine. Please install cordova via `npm i -g cordova`'
            end

            project_creator.create
        end

    end
end
