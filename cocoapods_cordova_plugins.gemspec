# coding: utf-8

Gem::Specification.new do |s|
  s.name        = 'cocoapods-cordova-plugins'
  s.version     = '0.0.1'
  s.date        = '2017-08-08'
  s.summary     = "Add cordova dependencies to existing iOS project"
  s.description = "Add cordova dependencies to existing iOS project"
  s.authors     = ["Isupov Il'ya"]
  s.email       = 'ilia.isupov@rakuten.com'
  s.homepage    = ''
  s.license     = 'MIT'

  s.files       = Dir['lib/**/*.rb']
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'cocoapods', '~> 1.2'
  s.add_runtime_dependency 'xcodeproj', '~> 1.5'
end
