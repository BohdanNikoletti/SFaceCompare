Pod::Spec.new do |s|
  s.name             = 'SFaceCompare'
  s.version          = '2.6.1'
  s.summary          = 'Simple lib fro iOS to find and compare faces.'
  s.requires_arc     = true
  s.static_framework = true
  s.swift_version    = '4.2'
  s.description      = <<-DESC
  SFaceCompare is an simple libray for iOS to find and compare faces. SFaceCompare works on top of dlib and OpenCV libraries.
  With usage of trained model.
                       DESC

  s.homepage         = 'https://github.com/BohdanNikoletti/SFaceCompare'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bohdan Mihiliev' => 'bohdanrose1@gmail.com' }
  s.source           = { :git => 'https://github.com/BohdanNikoletti/SFaceCompare.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.3'

  s.source_files = 'SFaceCompare/Classes/**/*'
  s.vendored_frameworks = 'SFaceCompare/SameFace.framework'
end
