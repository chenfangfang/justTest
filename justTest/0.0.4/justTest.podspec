
Pod::Spec.new do |s|

  s.name         = "justTest"
  s.version      = "0.0.4"
  s.summary      = "justTest pod"


  s.homepage     = "https://github.com/chenfangfang/justTest"

  s.license      = {:type => "MIT ,Version 0.0.3", :text => "FILE_LICENSE"}
  s.author       = { "陈方方" => "2327657587@qq.com" }

  s.source       = { :git => "https://github.com/chenfangfang/justTest.git", :tag => "#{s.version}" }



  s.resources  = "*.{h,m}"

end
