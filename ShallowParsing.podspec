#
# Be sure to run `pod lib lint ShallowParsing.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShallowParsing'
  s.version          = '0.0.2'
  s.summary          = 'XML Shallow Parsing.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
XML Shallow Parsing with Regular Expressions.
                       DESC

  s.homepage         = 'https://github.com/hectr/ShallowParsing'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hectr' => 'h@mrhector.me' }
  s.source           = { :git => 'https://github.com/hectr/ShallowParsing.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hectormarquesra'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  
  # s.resource_bundles = {
  #   'ShallowParsing' => ['ShallowParsing/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.frameworks = 'Foundation'

  s.default_subspec = 'XMLMatcher'

  s.subspec 'Regex' do |regex|
    regex.source_files = 'ShallowParsing/Regex/*'
  end

  s.subspec 'Analyzer' do |analyzer|
    analyzer.source_files = 'ShallowParsing/Analyzer/*'
    analyzer.dependency 'ShallowParsing/Regex'
  end

  s.subspec 'XMLMatcher' do |xmlmatcher|
    xmlmatcher.source_files = 'ShallowParsing/XMLMatcher/*'
    xmlmatcher.dependency 'ShallowParsing/Analyzer'
  end

end
