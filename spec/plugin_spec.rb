require 'cocoapods'
require 'cocoapods-core'
require 'plugin'

RSpec.describe CocoaPodsCordovaPlugins, 'on_pre_install' do
    before(:example) do
        allow(Kernel).to receive(:system) { true }
        allow_any_instance_of(CocoaPodsCordovaPlugins::ProjectCreator).to receive(:create)
    end

    it 'should raise if cordova is not installed on user machine' do
        allow(Kernel).to receive(:system) { nil }

        expect {
            CocoaPodsCordovaPlugins.on_pre_install(nil, {:plugins => []})
        }.to raise_error(Pod::Informative, /Cordova is missing/)
    end

    it 'should create cordova project' do
        expect_any_instance_of(CocoaPodsCordovaPlugins::ProjectCreator).to receive(:create)

        CocoaPodsCordovaPlugins.on_pre_install(nil, {:plugins => []})
    end
end
