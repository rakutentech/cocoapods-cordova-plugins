# CoaoaPods-Cordova-Plugins

This CocoaPods plugin enables using existing, public and private, cordova
plugins in iOS project.

Please note, that this project is in Proof of Concept stage. Current version is
strongly discouraged to be used anywhere.

## Configuring plugin

Config must be added to Podfile of source project.Config contains description
of cordova plugins that must be integrated to the source project.

Config example:

```ruby
plugin 'cocoapods-cordova-plugins', {
    :registry => 'https://registry.rakuten.appstudio.monaca.mobi',
    :plugins => [
        {
            :name => 'some-cordova-plugin',
            :version => '0.0.1',
            :params => {
                'foo': bar
            }
        }
    ]
}
```

## How it works

### Principle of operation

1. Attach to CocoaPods :before_install hook
2. Create temp cordova project
3. Add to it all plugins, listed in user's podfile
4. Build temp project
5. Copy plugins sources, resources and dependencies to special generated Pod
6. Add this pod to workspace, set for it copying of JS resources to client project

### Current implementation details

1. In source project directory `.build` folder created
2. Inside `.build` folder, `cordova_proj` folder created, in it temporary cordova
project instantiated
3. All plugins listed in `Podfile` are installed to temporary cordova project
4. In the `.build` folder `temp_podspec` folder created
5. From all plugins native sources are being copied to `temp_podspec/sources` folder
6. From all plugins JS files are being copied to `temp_podspec/resources/js`
7. Resources from All plugins + `config.xml` of generated cordova project are being
 copied to `temp_podspec/resources/res` folder
8. Temporary podspec definition is being generated, pointing at sources and
resources. In this podspec, all pods of the plugins listed as it's dependencies,
all system frameworks of the plugins listed as `weak_frameworks`.
9. Generated podspec added to source project as development pod
10. A build phase added to source project. This build phase needed to copy JS
sources and resources from temp podspec's framework folder to root of the app
bundle. It is needed because otherwise resources will be missing in the app.

## Known issues

1. No error handling in current prototype - if something goes wrong code will
crash in random place with terrible output
2. Huge cordova output to the console - need to silence it
3. Unit tests are almost irrelevant
4. Copying resources to the root may overwrite some resources of the app.
5. Copying config.xml of the temp cordova project may overwrite config.xml existing in project
5. Some cordova plugins require enabling iOS capabilities. Now nothing being done with it.
6. `.xib` files from plugins are not being converted to nib. This leads that it's can not be loaded by iOS with default instruments.
