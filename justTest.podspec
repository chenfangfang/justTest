
Pod::Spec.new do |s|

  s.name         = "justTest"
  s.version      = "0.0.1"
  s.summary      = "justTest pod"

  s.description  = <<-DESC
                   DESC

  s.homepage     = "http://github.com/chenfangfang/justTest"

  s.license      = "MIT"

  s.author             = { "陈方方" => "2327657587@qq.com" }

  s.source       = { :git => "http://github.com/chenfangfang/justTest.git", :tag => "#{s.version}" }



  s.source_files  = "justTest", "justTest/**/*.{h,m}"

end
