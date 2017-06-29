Pod::Spec.new do |spec|
  spec.name = "Pins"
  spec.version = "1.0.0"
  spec.summary = "Simple API for Auto Layout interfaces."
  spec.homepage = "https://github.com/jduff/Pins"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "John Duff" => 'duff.john@gmail.com' }

  spec.requires_arc = true

  spec.ios.deployment_target = "10"
  spec.osx.deployment_target = "10.10"
  
  spec.ios.framework  = 'UIKit'
  spec.osx.framework  = 'AppKit'

  spec.source = { git: "https://github.com/jduff/Pins.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "Pins/**/*.{h,swift}"
end
