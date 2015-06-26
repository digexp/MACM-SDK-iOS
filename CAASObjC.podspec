license = <<EOT
???
EOT

Pod::Spec.new do |s|
  s.name     = 'CAASObjC'
  s.version  = '1.0.0'
  s.license  = {:type => '???', :text => license}
  s.summary  = 'IBM Adaptive Content SDK'
  s.homepage = 'https://github.rtp.raleigh.ibm.com/caas/ios_sdk'
  s.social_media_url = 'https://twitter.com/ibmmobile'
  s.authors  = { "IBM" => "support@ibm.com" }
  s.source   = { :git => 'git@github.rtp.raleigh.ibm.com:caas/ios_sdk.git', :tag => s.version }
  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.private_header_files = "*Private.h"
  s.source_files = 'CAASObjC'

end
