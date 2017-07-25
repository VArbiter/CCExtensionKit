

Pod::Spec.new do |s|

    s.name         = "CCLocalLib"
    s.version      = "2.1.6"
    s.summary      = "CCLocalLib."

    s.description  = <<-DESC
    CCLocalLib for project .
                   DESC

    s.author       = { "冯明庆" => "elwinfrederick@163.com" }
    s.homepage = "https://github.com/VArbiter/CCLocalLibrary"
    s.license  = "MIT"
    s.platform     = :ios, "8.0"

    s.source = { :git => "https://github.com/VArbiter/CCLocalLibrary.git" , :tag => s.version.to_s}
    s.source_files  = "CCLocalLib", "CCLocalLib/**/*"

    s.frameworks = "Foundation" , "UIKit" , "AssetsLibrary" , "Photos" , "CoreGraphics" , "QuartzCore" , "SystemConfiguration" , "CoreTelephony" , "MobileCoreServices"

    s.dependency 'MBProgressHUD', '~> 1.0.0'
    s.dependency 'SDWebImage', '~> 3.8.2'
    s.dependency 'MJRefresh', '~> 3.1.12'
    s.dependency 'AFNetworking', '~> 3.1.0'
    s.requires_arc = true

end
