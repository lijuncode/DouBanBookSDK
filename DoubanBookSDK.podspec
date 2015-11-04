Pod::Spec.new do |s|

  s.name         = 'DoubanBookSDK'
  s.version      = '1.0'
  s.summary      = 'Douban book SDK'
  s.homepage     = 'https://github.com/likumb/DouBanBookSDK.git'
  s.author       = {'lijun' => 'likumb@163.com'}
  s.platform     = :ios, "8.0"
  s.source_files = 'DouBanBookSDK/DouBanBookSDK/*.{swift}'
  s.source       = { :git => "https://github.com/likumb/DouBanBookSDK.git", :tag => s.version }
  s.requires_arc  = true

end

