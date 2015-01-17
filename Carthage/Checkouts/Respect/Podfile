xcodeproj 'Respect'
workspace 'Respect'
# inhibit_all_warnings!

framework = 'XCTest'

# def import_pods
#     pod 'Quick',  :git => "https://github.com/Quick/Quick"
#     pod 'Nimble', :git => "https://github.com/Quick/Nimble"
# end

# target :ios do
#     platform :ios, '8.0'
#     link_with 'RespectiOSTests'
#     import_pods
# end

# target :osx do
#     platform :osx, '10.10'
#     link_with 'RespectTests'
#     import_pods
# end

post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['FRAMEWORK_SEARCH_PATHS'] = [ '$(DEVELOPER_DIR)/Platforms/MacOSX.platform/Developer/Library/Frameworks' ]
    end
  end
end


# platform :osx, '10.10'


# link_with 'Respect', 'RespectTests'

