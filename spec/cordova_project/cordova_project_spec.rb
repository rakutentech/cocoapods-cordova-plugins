require 'cordova_project/cordova_project'
require 'fakefs'
require 'fileutils'

RSpec.describe CocoaPodsCordovaPlugins::CordovaProject do
    context '#podfile_path' do
        it 'should return path to podfile' do
            project = CocoaPodsCordovaPlugins::CordovaProject.new('/cordova_project_dir')

            path = project.podfile_path

            expect(path).to eq('/cordova_project_dir/platforms/ios/Podfile')
        end
    end

    context '#list_native_sources' do
        before(:all) do
            FakeFS.activate!
        end

        before(:each) do
            FakeFS.clear!
        end

        after(:all) do
            FakeFS.deactivate!
        end

        it 'should include .h files of cordova plugins' do
            mk_dir_tree({
                '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/cordova-plugin': { 'header_file.h': '' },
                '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/another-cordova-plugin': { 'another_header_file.h': '' }
            })

            project = CocoaPodsCordovaPlugins::CordovaProject.new('/cordova_project_dir')
            plugin_sources = project.list_native_sources

            aggregate_failures 'resulting dirs list' do
                expect(plugin_sources.count).to eq(2)
                expect(plugin_sources).to include(
                    '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/cordova-plugin/header_file.h',
                    '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/another-cordova-plugin/another_header_file.h'
                )
            end
        end

        it 'should include .m files of cordova plugins' do
            mk_dir_tree({
                '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/cordova-plugin': { 'header_file.m': '' },
                '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/another-cordova-plugin': { 'another_header_file.m': '' }
            })

            project = CocoaPodsCordovaPlugins::CordovaProject.new('/cordova_project_dir')
            plugin_sources = project.list_native_sources

            aggregate_failures 'resulting dirs list' do
                expect(plugin_sources.count).to eq(2)
                expect(plugin_sources).to include(
                    '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/cordova-plugin/header_file.m',
                    '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/another-cordova-plugin/another_header_file.m'
                )
            end
        end

        it 'should include .swift files of cordova plugins' do
            mk_dir_tree({
                '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/cordova-plugin': { 'header_file.swift': '' },
                '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/another-cordova-plugin': { 'another_header_file.swift': '' }
            })

            project = CocoaPodsCordovaPlugins::CordovaProject.new('/cordova_project_dir')
            plugin_sources = project.list_native_sources

            aggregate_failures 'resulting dirs list' do
                expect(plugin_sources.count).to eq(2)
                expect(plugin_sources).to include(
                    '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/cordova-plugin/header_file.swift',
                    '/cordova_project_dir/platforms/ios/HelloCordova/Plugins/another-cordova-plugin/another_header_file.swift'
                )
            end
        end
    end
end
