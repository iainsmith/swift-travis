Pod::Spec.new do |spec|
    spec.name         = 'TravisClient'
    spec.version      = '0.2.0'
    spec.license      = { :type => 'MIT' }
    spec.homepage     = 'https://github.com/IainSmith/TravisClient'
    spec.authors      = { 'Iain Smith' => 'Iain@mountain23.com' }
    spec.summary      = 'Swifty Travis v3 API Client'
    spec.source       = { :git => 'https://github.com/IainSmith/travisClient.git', :tag => '0.2.0' }
    spec.source_files = 'Sources/**/*.swift'
    spec.ios.deployment_target  = '10.0'
    spec.osx.deployment_target  = '10.12'
    spec.swift_version = '4.0'
    spec.dependency 'Result', '~> 3.0.0'
end