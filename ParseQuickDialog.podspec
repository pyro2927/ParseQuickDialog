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
  s.framework     = 'Parse'
  s.xcconfig      = { 'FRAMEWORK_SEARCH_PATHS' => "$(PODS_ROOT)/Parse" , 'OTHER_LDFLAGS' => '-framework Parse'}
  s.prefix_header_contents = '#import <Parse/Parse.h>'
  s.dependency    'Parse'
  s.dependency    'QuickDialog'
end
