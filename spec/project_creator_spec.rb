require('project_creator');

RSpec.describe CocoaPodsCordovaPlugins::ProjectCreator do
    before(:example) do
        allow(Kernel).to receive(:system)
    end

    context '#isCordovaInstalled' do
        it 'should check is cordova exist by asking version of the installed cordova' do
            allow(Kernel).to receive(:system)

            expect(Kernel).to receive(:system).with('cordova', '--version')

            creator = CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []})
            creator.isCordovaInstalled
        end

        it 'should return true if cordova installed on machine' do
            allow(Kernel).to receive(:system) { true }

            creator = CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []})

            expect(creator.isCordovaInstalled).to eq true
        end

        it 'should return nil if cordova is not installed on machine' do
            allow(Kernel).to receive(:system) { nil }

            creator = CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []})

            expect(creator.isCordovaInstalled).to eq nil
        end
    end

    context '#create' do
        before(:each) do
            allow(FileUtils).to receive_messages(
                :rm_r => nil,
                :mkpath => nil,
                :chdir => nil
            )
        end

        it 'should clean tmp_build dir where cordova project will be created' do
            expect(FileUtils).to receive(:rm_r).with('./tmp_build', :force => true)

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}).create
        end

        it 'should recreate tmp_build dir in the project directory' do
            expect(FileUtils).to receive(:mkpath).with('./tmp_build')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}).create
        end

        it 'should open temp project dir' do
            expect(FileUtils).to receive(:chdir).with('./tmp_build')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}).create
        end

        it 'should create cordova project' do
            expect(Kernel).to receive(:system).with('cordova', 'create', '.')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}).create
        end

        it 'should add ios platform to cordova project' do
            expect(Kernel).to receive(:system).with('cordova', 'create', '.')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}).create
        end

        it 'should install plugins listed in the config' do
            expect(Kernel).to receive(:system).with('cordova plugin add some_random_plugin')

            CocoaPodsCordovaPlugins::ProjectCreator.new({
                :plugins => [{:name => 'some_random_plugin'}]
            }).create
        end

        it 'should install plugin of specific version if version for that plugin specified' do
            expect(Kernel).to receive(:system).with('cordova plugin add some_random_plugin@0.0.1')

            CocoaPodsCordovaPlugins::ProjectCreator.new({
                :plugins => [{
                    :name => 'some_random_plugin',
                    :version => '0.0.1'
                }]
            }).create
        end

        it 'should add variables in plugin if it specified in plugin config' do
            expect(Kernel).to receive(:system).with('cordova plugin add some_random_plugin --variable foo=bar --variable fizz=buzz')

            CocoaPodsCordovaPlugins::ProjectCreator.new({
                :plugins => [{
                    :name => 'some_random_plugin',
                    :params => {
                        'foo' => 'bar',
                        'fizz' => 'buzz'
                    }
                }]
            }).create
        end

        it 'should prepare cordova project for copying' do
            expect(Kernel).to receive(:system).with('cordova', 'prepare')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}).create
        end

        it 'should cd back to the root dir' do
            expect(FileUtils).to receive(:chdir).with('..')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}).create
        end
    end
end
