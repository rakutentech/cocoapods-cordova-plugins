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

RSpec.describe CocoaPodsCordovaPlugins, 'blabla' do
    it 'foo' do
        # # project = Xcodeproj::Project.open('/Users/ilia.isupov/Documents/prototypes/cocoapods-cordova-plugins/tmp_build/platforms/ios/HelloCordova.xcodeproj')
        # project = Xcodeproj::Project.open('/Users/ilia.isupov/Documents/cordova-plugins/cordova-plugin-rakuten-pnp/src/ios/Tests.xcodeproj')
        #
        
        #
        #
        #
        #
        project_podfile = Pod::Podfile.from_file('/Users/ilia.isupov/Documents/cordova-plugins/cordova-plugin-rakuten-pnp/src/ios/Podfile')
        CocoaPodsCordovaPlugins.on_pre_install(project_podfile, {
            :plugins => [
                {
                    :name => 'cordova-plugin-rakuten-discover',
                    :version => '0.0.4',
                    :params => {
                        'IOS_APP_NAME' => 'qa_app_ios',
                        'IOS_APP_REVISION' => '1',
                        'IOS_SERVICE_ID' => 'remdemoapp',
                        'IOS_SUBSCRIPTION_KEY' => '55d9ef39564c4a0bbc34daecaf8823e4',
                        'STAGING' => 'false'
                    }
                },
                {
                    :name => 'cordova-plugin-rakuten-auth',
                    :version => '0.0.1',
                    :params => {
                        'CLIENT_ID' => 'rmsdk_qa',
                        'CLIENT_SECRET' => 'h5RdcGQVwlHB15K3jI3k8pfLkvkUjnc7brDVY0w1FU1v',
                        'SCOPES' => '90days@Access,90days@Refresh,idinfo_read_encrypted_easyid,idinfo_read_openid,memberinfo_read_basic,memberinfo_read_name,memberinfo_read_point,memberinfo_read_rank,memberinfo_read_pointsummary,memberinfo_read_info,memberinfo_read_details,memberinfo_read_address,memberinfo_read_telephone,memberinfo_read_mail,gecp_point_read'
                    }
                },
                {
                    :name => 'cordova-plugin-rakuten-pnp',
                    :version => '0.0.3',
                    :params => {
                        "RAE_BASE_URL" => "https://app.rakuten.co.jp",
                        "PNP_VERSION" => "1",
                        "RAE_CLIENT_ID" => "rmsdk_qa",
                        "RAE_CLIENT_SECRET" => "w3aLJWREdlycPtbEtdhK1HKvzbpewZC1auhnygNIk9ji",
                        "PNP_CLIENT_ID" => "ecosystem_demoapp",
                        "PNP_CLIENT_SECRET" => "gXKoHAtCK2QVUGo2CCGNkKkygnjNIWOJ"
                    }
                }
            ]
        })

    end
end
