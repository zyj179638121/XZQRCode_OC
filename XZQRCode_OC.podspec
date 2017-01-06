Pod::Spec.new do |s|

  s.name         = "XZQRCode_OC"
  s.version      = "1.1"
  s.summary      = "XZQRCode_OC."

  s.description  = <<-DESC
                    this is XZQRCode_OC
                   DESC

  s.homepage     = "https://github.com/zyj179638121/XZQRCode_OC"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author       = { "zyj179638121" => "179638121@qq.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/zyj179638121/XZQRCode_OC.git", :tag => s.version.to_s }

  s.source_files  = "XZQRCode_OC/XZQRCode_OC/**/*.{h,m}"

  s.resource  = "XZQRCode_OC/Assets.xcassets"

  s.requires_arc = true

end
