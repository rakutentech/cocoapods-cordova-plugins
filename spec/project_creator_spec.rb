require('project_creator');

RSpec.describe CocoaPodsCordovaPlugins::ProjectCreator, '#isCordovaInstalled' do
    it 'should return true if cordova installed on machine' do
        allow(Kernel).to receive(:system) { true }

        creator = CocoaPodsCordovaPlugins::ProjectCreator.new(nil)

        expect(creator.isCordovaInstalled()).to eq true
    end

    it 'should return nil if cordova is not installed on machine' do
        allow(Kernel).to receive(:system) { nil }

        creator = CocoaPodsCordovaPlugins::ProjectCreator.new(nil)

        expect(creator.isCordovaInstalled()).to eq nil
    end
end
