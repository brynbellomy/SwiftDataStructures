Pod::Spec.new do |s|
  s.name = 'Respect'
  s.version = '0.0.1'
  s.license = 'WTFPL'
  s.summary = 'Reusable tests for common protocols (in Swift).'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }
  s.license = { :type => 'WTFPL', :file => 'LICENSE.md' }
  s.homepage = 'https://github.com/brynbellomy/Respect'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'src/*.swift', 'src/**/*.swift'
  s.requires_arc = true

  s.framework = 'XCTest'
  s.dependency 'Quick'
  s.dependency 'Nimble'

  s.source = { :git => 'https://github.com/brynbellomy/Respect.git', :tag => s.version }
end
