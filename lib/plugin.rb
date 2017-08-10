require 'cocoapods-core'
require 'FileUtils'

module CocoaPodsCordovaPlugins
    class << self
        include FileUtils

        Pod::HooksManager.register('cocoapods-cordova-plugins', :pre_install) do |context, options|
            puts 'Inspecting context.podfile'
            puts '--------------------------'
            puts context.podfile.inspect
            puts '--------------------------'
            puts options.inspect
            puts 'Inspecting options'
            puts '--------------------------'
        end

    end
end
