Pod::Spec.new do |s|
  s.name          = "ParseQuickDialog"
  s.version       = "0.0.1"
  s.summary       = "A drop in framework to enable easy adminability to your Parse objects"
  s.homepage      = "https://github.com/pyro2927/ParseQuickDialog"
  s.license       = "MIT"
  s.author        = { "Joe Pintozzi" => "joseph.pintozzi@gmail.com" }
  s.source        = { :git => "https://github.com/pyro2927/ParseQuickDialog.git" }
  s.platform      = :ios, '6.0'
  s.source_files  = 'ParseQuickDialog/parseQuickDialog/*.{h,m}'
  s.requires_arc  = true
  s.dependency    = 'Parse'
  s.dependency    = 'QuickDialog', :podspec => "https://raw.github.com/pyro2927/QuickDialog/parse/QuickDialog.podspec"
end
