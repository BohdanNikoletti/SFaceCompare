#
# Be sure to run `pod lib lint SFaceCompare.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFaceCompare'
  s.version          = '0.1.0'
  s.summary          = 'Simple lib fro iOS to find and compare faces.'
  s.requires_arc     = true
  s.static_framework = true
  s.swift_version    = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  SFaceCompare is an simple libray for iOS to find and compare faces. SFaceCompare works on top of dlib and OpenCV libraries.
  With usage of trained model.
                       DESC

  s.homepage         = 'https://github.com/BohdanNikoletti/SFaceCompare'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bohdan Mihiliev' => 'bohdanrose1@gmail.com' }
  s.source           = { :git => 'https://github.com/BohdanNikoletti/SFaceCompare.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.3'

  s.source_files = 'SFaceCompare/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SFaceCompare' => ['SFaceCompare/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'OpenCV'
end
