#
# Be sure to run `pod lib lint Triangle.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Triangle"
  s.version          = "1.0.0"
  s.summary          = "Swift wrapper for Triangle.c."
  s.swift_version    = "4.2"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
                      A Swift framework for performing Delaunay Triangulation. Built on top of triangle.c
                     DESC

  s.homepage         = "https://github.com/wtsnz/Triangle"
  s.license          = 'MIT'
  s.author           = { "Will Townsend" => "will@townsend.io" }
  s.source           = { :git => "https://github.com/wtsnz/Triangle.git", :tag => s.version.to_s}
  s.social_media_url   = "http://twitter.com/wtsnz"

  s.ios.deployment_target = '8.0'
  #s.tvos.deployment_target = '9.0'
  #s.watchos.deployment_target = '2.0'
  #s.osx.deployment_target = '10.9'
  s.requires_arc = true

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }

  s.source_files = 'Triangle/*.{swift,h}', 'Triangle/triangle/*.{c,h}'
  s.public_header_files = 'Triangle/triangle/*.h'
  s.pod_target_xcconfig = {
      'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/Triangle/triangle/**',
      'LIBRARY_SEARCH_PATHS' => '$(SRCROOT)/Triangle/'
  }

 s.preserve_paths  = 'Triangle/triangle/module.modulemap'

end
