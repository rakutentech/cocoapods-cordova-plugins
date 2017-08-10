require 'cocoapods-core'
require 'FileUtils'

module CocoaPodsCordovaPlugins
    class << self
        include FileUtils

        Pod::HooksManager.register('cocoapods-cordova-plugins', :pre_install) do |context, options|
            puts context.podfile.inspect
            puts options.inspect
        end
    end
end
