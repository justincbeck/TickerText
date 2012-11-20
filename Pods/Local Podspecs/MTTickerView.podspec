Pod::Spec.new do |s|
  s.name         = "MTTickerView"
  s.version      = "0.0.1"
  s.summary      = "A short description of MTTickerView."
  s.homepage     = "https://github.com/willowtreeapps/MTTickerView.git"
  s.license      = 'Proprietary'
  s.author       = { "WillowTree Apps" => "" }
  s.source       = { :git => "git@github.com:willowtreeapps/MTTickerView.git", :tag => s.version }
  s.source_files = 'Classes/*.{h,m}'
  s.requires_arc = true
  s.platform     = :ios, '5.0'
  s.frameworks   = 'QuartzCore'
end
