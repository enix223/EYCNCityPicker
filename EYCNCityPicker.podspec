Pod::Spec.new do |s|
  s.name         = "EYCNCityPicker"
  s.version      = "0.0.1"
  s.summary      = "iOS中国行政区域picker控件，数据来源于高德web API"
  s.homepage     = "https://github.com/enix223/EYCNCityPicker"
  s.license      = "MIT"
  s.author             = { "Enix Yu" => "enix223@163.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/enix223/EYCNCityPicker.git", :tag => "#{s.version}" }
  s.source_files  = "Sources", "Sources/**/*.{h,m}"
  s.resources = "Sources/**/*.{xib}"
  s.exclude_files = "Sources/Exclude"
  s.requires_arc = true
end
