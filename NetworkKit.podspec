Pod::Spec.new do |s|

s.name         = "NetworkKit"
s.version      = "0.2"
s.summary      = "NetworkKit"

s.homepage     = "https://github.com/vitkuzmenko/NetworkKit.git"

s.license = 'MIT'

s.author             = { "Vitaliy" => "kuzmenko.v.u@gmail.com" }
s.social_media_url   = "http://twitter.com/vitkuzmenko"

s.ios.deployment_target = '9.0'
s.tvos.deployment_target = '9.0'
s.osx.deployment_target = '10.10'

s.source       = { :git => s.homepage, :tag => s.version.to_s }

s.source_files  = "Source/*/*.swift"

s.requires_arc = 'true'

s.pod_target_xcconfig = {
'SWIFT_VERSION' => '4.0',
}

s.dependency 'Alamofire', '~> 4.7.1'
s.dependency 'ReachabilitySwift', '~> 4.1.0'
s.dependency 'ObjectMapper', '~> 3.1.0'

end
