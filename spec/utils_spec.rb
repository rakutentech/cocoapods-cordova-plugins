require 'utils'

RSpec.describe CocoaPodsCordovaPlugins, '#is_cordova_installed' do
    it 'should check is cordova exist by asking version of the installed cordova' do
        expect(Kernel).to receive(:system).with('cordova', '--version')

        CocoaPodsCordovaPlugins.is_cordova_installed
    end

    it 'should return true if cordova installed on machine' do
        allow(Kernel).to receive(:system) { true }

        expect(CocoaPodsCordovaPlugins.is_cordova_installed).to eq true
    end

    it 'should return nil if cordova is not installed on machine' do
        allow(Kernel).to receive(:system) { nil }

        expect(CocoaPodsCordovaPlugins.is_cordova_installed).to eq nil
    end
end
