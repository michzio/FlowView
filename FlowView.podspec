Pod::Spec.new do |s|

  s.name = "FlowView"
  s.version = "0.2.2"
  s.summary = "SwiftUI wizard-like TabView."

  s.swift_version = '5.7'
  s.platform = :ios
  s.ios.deployment_target = '14.0'

  s.description = <<-DESC
  SwiftUI wizard-like TabView.
  DESC

  s.homepage = "https://github.com/michzio/FlowView"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Michał Ziobro" => "swiftui.developer@gmail.com" }

  s.source = { :git => "https://github.com/michzio/FlowView.git", :tag => "#{s.version}" }

  s.source_files = "Sources/**/*.swift"
  s.exclude_files = [
    "Tests/**/*.swift"
  ]

  s.framework = "UIKit"
  
end
