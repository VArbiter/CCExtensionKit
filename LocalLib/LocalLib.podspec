

Pod::Spec.new do |s|

    s.name         = "LocalLib"
    s.version      = "1.2.2"
    s.summary      = "LocalLib."

    s.description  = <<-DESC
    LocalLib for ym_sell_ios
                   DESC

    s.author       = { "冯明庆" => "elwinfrederick@163.com" }
    s.homepage = "https://github.com/VArbiter/CCLocalLibrary"
    s.license  = "MIT"
    s.platform     = :ios, "8.0"

    s.source = { :path => "LocalLib"}
    s.source_files  = "LocalLib", "LocalLib/**/*"

    s.dependency 'MBProgressHUD', '~> 1.0.0'
    s.dependency 'SDWebImage', '~> 3.8.2'
    s.dependency 'MJRefresh', '~> 3.1.12'
    s.dependency 'AFNetworking', '~> 3.1.0'
    s.requires_arc = true

end
