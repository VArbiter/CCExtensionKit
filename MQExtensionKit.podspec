Pod::Spec.new do |s|

    s.name         = "MQExtensionKit"
    s.version      = "4.0.0"
    s.summary      = "MQExtensionKit."

    s.description  = <<-DESC
    original was "MQExtensionKit" . due to some reason . 'MQExtensionKit' was deprecated .
                   DESC

    s.author       = { "冯明庆" => "elwinfrederick@163.com" }
    s.homepage = "https://github.com/VArbiter/MQExtensionKit"
    s.license  = "MIT"
    s.platform     = :ios, "8.0"

    s.source = { :git => "https://github.com/VArbiter/MQExtensionKit.git" , :tag => s.version.to_s}
    s.compiler_flags = '-Wstrict-prototypes'

    s.default_subspec = 'MQCore'

    s.subspec 'MQCore' do |core|
      core.source_files = '../*.{h}'
      core.dependency 'MQExtensionKit/MQData'
      core.dependency 'MQExtensionKit/MQView'
      core.dependency 'MQExtensionKit/MQRuntime'
    end

    s.subspec 'MQFull' do |full|
      full.dependency 'MQExtensionKit/MQCore'
      full.dependency 'MQExtensionKit/MQRouter'
      full.dependency 'MQExtensionKit/MQOrigin'
    end

      s.subspec 'MQCommon' do |common|
        common.source_files = 'MQExtensionKit/MQExtensionKit/MQCommon/**/*'
        common.frameworks = "Foundation", "UIKit", "AVFoundation" , "SystemConfiguration" , "AdSupport" # , "Darwin"
        common.weak_frameworks = "Photos" , "AssetsLibrary"
      end

      s.subspec 'MQProtocol' do |protocol|
        protocol.source_files = 'MQExtensionKit/MQExtensionKit/MQProtocol/**/*'
        protocol.dependency 'MQExtensionKit/MQCommon'
      end

      s.subspec 'MQRuntime' do |runtime|
        runtime.source_files = 'MQExtensionKit/MQExtensionKit/MQRuntime/**/*'
      end

      s.subspec 'MQRouter' do |router|
        router.source_files = 'MQExtensionKit/MQExtensionKit/MQRouter/**/*'
        router.frameworks = "Foundation"
        router.dependency 'MGJRouter', '>= 0.10.0'
      end

      s.subspec 'MQData' do |data|
        data.source_files = 'MQExtensionKit/MQExtensionKit/MQData/**/*'
        data.dependency 'MQExtensionKit/MQProtocol'
        data.frameworks = "MobileCoreServices"
      end

      s.subspec 'MQView' do |view|
        view.source_files = 'MQExtensionKit/MQExtensionKit/MQView/**/*'
        view.frameworks = "CoreGraphics" , "QuartzCore"
        view.dependency 'MQExtensionKit/MQProtocol'
      end

      s.subspec 'MQOrigin' do |origin|
        origin.source_files = 'MQExtensionKit/MQExtensionKit/MQOrigin/**/*'
        origin.dependency 'MQExtensionKit/MQCore'
        origin.dependency 'MQExtensionKit/MQMedia'
        origin.frameworks = "StoreKit" , "AdSupport" , "AVFoundation" , "CoreLocation"
        origin.weak_frameworks = "Photos" , "WebKit"
      end

      s.subspec 'MQMedia' do |media|
        media.source_files = 'MQExtensionKit/MQExtensionKit/MQMedia/**/*'
        media.dependency 'MQExtensionKit/MQCore'
        media.frameworks = 'AVFoundation' , "AssetsLibrary"
        media.weak_frameworks = "Photos"
      end

      s.subspec 'MQDatabase' do |database|
        database.source_files = 'MQExtensionKit/MQExtensionKit/MQDatabase/**/*'
        database.dependency 'Realm', '>= 3.7.5'
        database.dependency 'FMDB', '>= 2.7.2'
        database.frameworks = "Foundation"
      end

      s.subspec 'MQCustom' do |custom|
        custom.source_files = 'MQExtensionKit/MQExtensionKit/MQCustom/**/*'
        custom.dependency 'MQExtensionKit/MQCore'
        custom.dependency 'AFNetworking/Reachability', '>= 3.2.1'
        custom.dependency 'AFNetworking/UIKit', '>= 3.2.1'
        custom.dependency 'SDWebImage', '>= 4.4.2'
        custom.dependency 'MJRefresh', '>= 3.1.12'
        custom.dependency 'MBProgressHUD', '>= 1.1.0'
        custom.dependency 'SVProgressHUD', '>= 2.2.5'
        custom.frameworks =  "SystemConfiguration" , "CoreTelephony" , "MobileCoreServices", "ImageIO"
        custom.weak_frameworks = "WebKit"
      end

    s.requires_arc = true

end
