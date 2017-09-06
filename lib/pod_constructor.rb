require 'fileutils'
require 'pathname'
require 'fs_helper'
require 'erb'

PODSPEC_DIR = 'temp_podspec'
SOURCES_DIR = 'source'
RESOURCES_DIR = 'resources'

module CocoaPodsCordovaPlugins
    class PodConstructor
        def initialize(cordova_project, build_dir)
            raise ArgumentError, 'Missing cordova project' unless cordova_project
            raise ArgumentError, 'Missing build directory' unless build_dir

            @project = cordova_project
            @podspec_dir = File.join(build_dir, PODSPEC_DIR)
        end

        def construct_pod
            CocoaPodsCordovaPlugins::FSHelper.recreate_dir(@podspec_dir)

            copy_native_sources
            copy_js_sources
            copy_resources

            podspec = construct_podspec

            return write_podspec(podspec)
        end

        private
        def copy_native_sources
            sources_dir = File.join(@podspec_dir, SOURCES_DIR)
            CocoaPodsCordovaPlugins::FSHelper.recreate_dir(sources_dir)

            @project.list_native_sources.each do |source_path|
                dest_path = File.join(sources_dir, File.basename(source_path))

                FileUtils.cp source_path, dest_path
            end
        end

        def copy_js_sources
            sources_dir = File.join(@podspec_dir, RESOURCES_DIR, 'js')
            CocoaPodsCordovaPlugins::FSHelper.recreate_dir(sources_dir)

            @project.list_js_sources.each do |source_path|
                dest_path = File.join(sources_dir, File.basename(source_path))

                FileUtils.copy_entry(source_path, dest_path)
            end
        end

        def copy_resources
            sources_dir = File.join(@podspec_dir, RESOURCES_DIR, 'res')
            CocoaPodsCordovaPlugins::FSHelper.recreate_dir(sources_dir)

            resources = @project.list_resources
            resources << @project.cordova_config_file

            resources.each do |resource_path|
                dest_path = File.join(sources_dir, File.basename(resource_path))

                FileUtils.copy_entry resource_path, dest_path
            end
        end

        def construct_podspec
            CocoaPodsCordovaPlugins::PodConstructor::PodspecConstructor.new(@project).construct_podspec
        end

        def write_podspec(podspec)
            podspec_dest_path = File.join(@podspec_dir, 'cordova_plugins.podspec')

            File.write(podspec_dest_path, podspec)

            return podspec_dest_path
        end

        class PodspecConstructor
            def initialize(cordova_project)
                @frameworks = cordova_project.list_frameworks
                @dependencies = cordova_project.podfile.pods

                @dependencies.push(:name => 'Cordova')
            end

            def construct_podspec
                podspec_template = Pathname.new(File.join(Pathname(__dir__), '..', 'templates', 'cordova_plugins.podspec.erb')).read

                ERB.new(podspec_template, nil, '-').result(binding)
            end

            attr_accessor :frameworks, :dependencies
        end
    end
end
