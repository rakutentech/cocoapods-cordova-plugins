require 'cocoapods'
require 'cocoapods-core'
require 'xcodeproj'
require 'plugin'

RSpec.describe CocoaPodsCordovaPlugins, 'on_pre_install' do
    before(:example) do
        allow(CocoaPodsCordovaPlugins).to receive(:is_cordova_installed) { true }
        allow_any_instance_of(CocoaPodsCordovaPlugins::ProjectCreator).to receive(:create).and_return(mk_cordova_proj_stub())
        allow_any_instance_of(CocoaPodsCordovaPlugins::PodsInjector).to receive(:inject)
    end

    it 'should raise if cordova is not installed on user machine' do
        allow(CocoaPodsCordovaPlugins).to receive(:is_cordova_installed) { nil }

        expect {
            CocoaPodsCordovaPlugins.on_pre_install({}, {:plugins => []})
        }.to raise_error(Pod::Informative, /Cordova is missing/)
    end

    it 'should create cordova project' do
        expect_any_instance_of(CocoaPodsCordovaPlugins::ProjectCreator).to receive(:create)

        CocoaPodsCordovaPlugins.on_pre_install({}, {:plugins => []})
    end

    it 'should inject cocoapods deps of cordova plugins to podfile of source project' do
        project_stub = mk_cordova_proj_stub()
        allow_any_instance_of(CocoaPodsCordovaPlugins::ProjectCreator).to receive(:create).and_return(project_stub)

        expect_any_instance_of(CocoaPodsCordovaPlugins::PodsInjector).to receive(:inject).with(project_stub)

        CocoaPodsCordovaPlugins.on_pre_install({}, {:plugins => []})
    end
end

def mk_cordova_proj_stub
    project_stub = double('cordova_project')

    allow(project_stub).to receive(:podfile_path).and_return('podfile_path')

    return project_stub
end
