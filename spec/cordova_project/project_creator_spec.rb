require 'fileutils'
require 'cordova_project/project_creator'
require 'fs_helper'

RSpec.describe CocoaPodsCordovaPlugins::ProjectCreator do
    before(:example) do
        allow(Kernel).to receive(:system)
    end

    context '#create' do
        before(:each) do
            allow(CocoaPodsCordovaPlugins::FSHelper).to receive_messages(
                :recreate_dir => nil
            )

            allow(Dir).to receive(:chdir).and_yield()
        end

        it 'should recreate cordova project dir' do
            expect(CocoaPodsCordovaPlugins::FSHelper).to receive(:recreate_dir).with('/build_dir/cordova_proj')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}, '/build_dir').create
        end

        it 'should cd to cordova project dir' do
            expect(Dir).to receive(:chdir).with('/build_dir/cordova_proj')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}, '/build_dir').create
        end

        it 'should create cordova project' do
            expect(Kernel).to receive(:system).with('cordova', 'create', '.')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}, 'default_dir').create
        end

        it 'should add ios platform to cordova project' do
            expect(Kernel).to receive(:system).with('cordova', 'create', '.')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}, 'default_dir').create
        end

        it 'should install plugins listed in the config' do
            expect(Kernel).to receive(:system).with('cordova plugin add some_random_plugin')

            CocoaPodsCordovaPlugins::ProjectCreator.new({
                :plugins => [{:name => 'some_random_plugin'}]
            }, 'default_dir').create
        end

        it 'should install plugin of specific version if version for that plugin specified' do
            expect(Kernel).to receive(:system).with('cordova plugin add some_random_plugin@0.0.1')

            CocoaPodsCordovaPlugins::ProjectCreator.new({
                :plugins => [{
                    :name => 'some_random_plugin',
                    :version => '0.0.1'
                }]
            }, 'default_dir').create
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
            }, 'default_dir').create
        end

        it 'should prepare cordova project for copying' do
            expect(Kernel).to receive(:system).with('cordova', 'prepare')

            CocoaPodsCordovaPlugins::ProjectCreator.new({:plugins => []}, 'default_dir').create
        end
    end
end

# RSpec.describe CocoaPodsCordovaPlugins do
#     it 'bla' do
#         CocoaPodsCordovaPlugins::ProjectCreator.new({
#             :plugins => [
#                 {
#                     :name => 'cordova-plugin-rakuten-discover',
#                     :version => '0.0.4',
#                     :params => {
#                         'IOS_APP_NAME' => 'qa_app_ios',
#                         'IOS_APP_REVISION' => '1',
#                         'IOS_SERVICE_ID' => 'remdemoapp',
#                         'IOS_SUBSCRIPTION_KEY' => '55d9ef39564c4a0bbc34daecaf8823e4',
#                         'STAGING' => 'false'
#                     }
#                 },
#                 {
#                     :name => 'cordova-plugin-rakuten-auth',
#                     :version => '0.0.1',
#                     :params => {
#                         'CLIENT_ID' => 'rmsdk_qa',
#                         'CLIENT_SECRET' => 'h5RdcGQVwlHB15K3jI3k8pfLkvkUjnc7brDVY0w1FU1v',
#                         'SCOPES' => '90days@Access,90days@Refresh,idinfo_read_encrypted_easyid,idinfo_read_openid,memberinfo_read_basic,memberinfo_read_name,memberinfo_read_point,memberinfo_read_rank,memberinfo_read_pointsummary,memberinfo_read_info,memberinfo_read_details,memberinfo_read_address,memberinfo_read_telephone,memberinfo_read_mail,gecp_point_read'
#                     }
#                 }
#             ]
#         }).create
#     end
# end
