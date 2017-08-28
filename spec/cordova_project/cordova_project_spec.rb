require 'cordova_project/cordova_project'

RSpec.describe CocoaPodsCordovaPlugins::CordovaProject do
    before(:each) do
        allow(Kernel).to receive(:system)
    end

    context '#isCordovaInstalled' do
        it 'should check is cordova exist by asking version of the installed cordova' do
            expect(Kernel).to receive(:system).with('cordova', '--version')

            CocoaPodsCordovaPlugins::CordovaProject.new({:plugins => []}, 'default_dir').isCordovaInstalled
        end

        it 'should return true if cordova installed on machine' do
            allow(Kernel).to receive(:system) { true }

            creator = CocoaPodsCordovaPlugins::CordovaProject.new({:plugins => []}, 'default_dir')

            expect(creator.isCordovaInstalled).to eq true
        end

        it 'should return nil if cordova is not installed on machine' do
            allow(Kernel).to receive(:system) { nil }

            creator = CocoaPodsCordovaPlugins::CordovaProject.new({:plugins => []}, 'default_dir')

            expect(creator.isCordovaInstalled).to eq nil
        end
    end
end
