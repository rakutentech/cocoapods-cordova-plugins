require 'fs_helper'
require 'fakefs/safe'

RSpec.describe CocoaPodsCordovaPlugins::FSHelper do
    before(:all) do
        FakeFS.activate!
    end

    before(:each) do
        FakeFS.clear!
    end

    after(:all) do
        FakeFS.deactivate!
    end

    context '#recreate_dir' do
        it 'should create dir by passed path if it does not exist' do
            CocoaPodsCordovaPlugins::FSHelper.recreate_dir('dir')

            expect(Dir.exists? 'dir').to eq(true)
        end

        it 'should not throw if passed dir already exitst' do
            expect {
                CocoaPodsCordovaPlugins::FSHelper.recreate_dir('dir')
            }.to_not raise_error
        end

        it 'should purge files from dir by passed path' do
            mk_dir_tree({
                'dir': {
                    'file.txt': ''
                }
            })

            CocoaPodsCordovaPlugins::FSHelper.recreate_dir('dir')

            expect(File.exists? 'dir/file.txt').to eq(false)
        end

        it 'should purge subdirs from dir passed by path' do
            mk_dir_tree({
                'dir': {
                    'dir/subdir': {}
                }
            })

            CocoaPodsCordovaPlugins::FSHelper.recreate_dir('dir')

            expect(Dir.exist? 'dir/subdir').to eq(false)
        end
    end

    context '#list_dirs' do
        it 'should return list of subdirs located in passed dir' do
            mk_dir_tree({
                'dir': {
                    'subdir': {},
                    'another_subdir': {}
                }
            })

            list = CocoaPodsCordovaPlugins::FSHelper.list_dirs('dir')

            aggregate_failures 'resulting dirs list' do
                expect(list.count).to eq(2)
                expect(list).to include('dir/subdir', 'dir/another_subdir')
            end
        end

        it 'should not include files in list' do
            mk_dir_tree({
                'dir': {
                    'file.txt': ''
                }
            })

            list = CocoaPodsCordovaPlugins::FSHelper.list_dirs('dir')

            expect(list.count).to eq(0)

        end

        it 'should not include . and .. paths to the list' do
            mk_dir_tree({
                'dir': {}
            })

            list = CocoaPodsCordovaPlugins::FSHelper.list_dirs('dir')

            expect(list.count).to eq(0)
        end
    end

    context '#list_files' do
        it 'should list all files in passed dir matching passed regex' do
            mk_dir_tree({
                'dir': {
                    'file.txt': '',
                    'another_file.txt': ''
                }
            })

            list = CocoaPodsCordovaPlugins::FSHelper.list_files('dir', /.txt$/)

            aggregate_failures 'resulting file list' do
                expect(list.count).to eq(2)
                expect(list).to include('dir/file.txt', 'dir/another_file.txt')
            end
        end

        it 'should not add to list files not matching passed regex' do
            mk_dir_tree({
                'dir': {
                    'file.h': ''
                }
            })

            list = CocoaPodsCordovaPlugins::FSHelper.list_files('dir', /.txt$/)

            expect(list.count).to eq(0)
        end

        it 'should not add directories to resulting list' do
            mk_dir_tree({
                'dir': {
                    'subdir': {}
                }
            })

            list = CocoaPodsCordovaPlugins::FSHelper.list_files('dir', /.txt$/)

            expect(list.count).to eq(0)
        end
    end
end
