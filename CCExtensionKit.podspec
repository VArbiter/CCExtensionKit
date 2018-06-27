Pod::Spec.new do |s|

    s.name         = "CCExtensionKit"
    s.version      = "4.0.0"
    s.summary      = "CCExtensionKit."

    s.description  = <<-DESC
    original was "CCLocalLib" . and it's has an compare kit called 'CCChainKit'.
                   DESC

    s.author       = { "冯明庆" => "elwinfrederick@163.com" }
    s.homepage = "https://github.com/VArbiter/CCExtensionKit"
    s.license  = "MIT"
    s.platform     = :ios, "8.0"

    s.source = { :git => "https://github.com/VArbiter/CCExtensionKit.git" , :tag => s.version.to_s}
    s.compiler_flags = '-Wstrict-prototypes'

    s.default_subspec = 'CCCore'

    s.subspec 'CCCore' do |core|
      core.source_files = 'CCExtensionKit/*.{h}'
      core.dependency 'CCExtensionKit/CCData'
      core.dependency 'CCExtensionKit/CCView'
      core.dependency 'CCExtensionKit/CCRuntime'
    end

    s.subspec 'CCFull' do |full|
      full.dependency 'CCExtensionKit/CCCore'
      full.dependency 'CCExtensionKit/CCRouter'
      full.dependency 'CCExtensionKit/CCOrigin'
    end

      s.subspec 'CCCommon' do |common|
        common.source_files = 'CCExtensionKit/CCExtensionKit/CCCommon/**/*'
        common.frameworks = "Foundation", "UIKit", "AVFoundation" , "Darwin" , "SystemConfiguration" , "AdSupport"
        common.weak_frameworks = "Photos" , "AssetsLibrary"
      end

      s.subspec 'CCProtocol' do |protocol|
        protocol.source_files = 'CCExtensionKit/CCExtensionKit/CCProtocol/**/*'
        protocol.dependency 'CCExtensionKit/CCCommon'
      end

      s.subspec 'CCRuntime' do |runtime|
        runtime.source_files = 'CCExtensionKit/CCExtensionKit/CCRuntime/**/*'
      end

      s.subspec 'CCRouter' do |router|
        router.source_files = 'CCExtensionKit/CCExtensionKit/CCRouter/**/*'
        router.frameworks = "Foundation"
        router.dependency 'MGJRouter', '~> 0.9.3'
      end

      s.subspec 'CCData' do |data|
        data.source_files = 'CCExtensionKit/CCExtensionKit/CCData/**/*'
        data.dependency 'CCExtensionKit/CCProtocol'
        data.frameworks = "MobileCoreServices"
      end

      s.subspec 'CCView' do |view|
        view.source_files = 'CCExtensionKit/CCExtensionKit/CCView/**/*'
        view.frameworks = "CoreGraphics" , "QuartzCore"
        view.dependency 'CCExtensionKit/CCProtocol'
      end

      s.subspec 'CCOrigin' do |origin|
        origin.source_files = 'CCExtensionKit/CCExtensionKit/CCOrigin/**/*'
        origin.dependency 'CCExtensionKit/CCCore'
        origin.dependency 'CCExtensionKit/CCMedia'
        origin.frameworks = "StoreKit" , "AdSupport" , "AVFoundation" , "CoreLocation"
        origin.weak_frameworks = "Photos" , "WebKit"
      end

      s.subspec 'CCMedia' do |media|
        media.source_files = 'CCExtensionKit/CCExtensionKit/CCMedia/**/*'
        media.dependency 'CCExtensionKit/CCCore'
        media.frameworks = 'AVFoundation' , "AssetsLibrary"
        media.weak_frameworks = "Photos"
      end

      s.subspec 'CCDataBase' do |dataBase|
        dataBase.source_files = 'CCExtensionKit/CCExtensionKit/CCDataBase/**/*'
        dataBase.dependency 'Realm', '~> 2.10.2'
        dataBase.dependency 'FMDB', '~> 2.7.2'
        dataBase.frameworks = "Foundation"
      end

      s.subspec 'CCCustom' do |custom|
        custom.source_files = 'CCExtensionKit/CCExtensionKit/CCCustom/**/*'
        custom.dependency 'CCExtensionKit/CCCore'
        custom.dependency 'AFNetworking/Reachability', '~> 3.1.0'
        custom.dependency 'AFNetworking/UIKit', '~> 3.1.0'
        custom.dependency 'SDWebImage', '~> 4.2.0'
        custom.dependency 'MJRefresh', '~> 3.1.12'
        custom.dependency 'MBProgressHUD', '~> 1.0.0'
        custom.frameworks =  "SystemConfiguration" , "CoreTelephony" , "MobileCoreServices", "ImageIO"
        custom.weak_frameworks = "WebKit"
      end

    s.requires_arc = true

end
