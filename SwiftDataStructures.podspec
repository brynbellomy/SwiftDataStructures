Pod::Spec.new do |s|
  s.name = 'SwiftDataStructures'
  s.version = '0.0.2'
  s.license = 'WTFPL'
  s.summary = 'Basic data structures (LinkedList, Queue, Stack) that the Swift stdlib probably should have.'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }
  s.license = { :type => 'WTFPL', :file => 'LICENSE.md' }
  s.homepage = 'https://github.com/brynbellomy/SwiftDataStructures'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'Classes/*.swift'
  s.requires_arc = true

  s.source = { :git => 'https://github.com/brynbellomy/SwiftDataStructures.git', :tag => s.version }
end
