require 'xcodeproj'

module CocoaPodsCordovaPlugins
    class CopierScriptInjector
        def initialize(context, config)
            raise ArgumentError, 'Missing post-install context' unless context
            raise ArgumentError, 'Missing plugin config' unless config

            @context = context
            @config = config
        end

        def inject
            @context.umbrella_targets.each do |umbrella|
                umbrella.user_targets.each do |target|
                    create_or_update_build_phase(target)
                end

                umbrella.user_project.save
            end
        end

        def create_or_update_build_phase(target)
            build_phase_name = '[CocoaPods plugins] Copy JS sources'
            script = read_copier_script

            existing_phase = target.build_phases.select {|ph| ph.is_a?(Xcodeproj::Project::Object::PBXShellScriptBuildPhase)}.find {|ph| ph.name.end_with?(build_phase_name)}
            phase = existing_phase || project.new(Xcodeproj::Project::Object::PBXShellScriptBuildPhase)

            phase.name = build_phase_name
            phase.shell_script = script

            target.build_phases << phase unless target.build_phases.include? phase
        end

        def read_copier_script
            Pathname.new(File.join(Pathname(__dir__), '..', 'templates', 'resource_copier.sh')).read
        end
    end
end
