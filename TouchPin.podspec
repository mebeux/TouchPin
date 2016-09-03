Pod::Spec.new do |spec|
  spec.name = "TouchPin"
  spec.version = "1.0.0"
  spec.summary = "Pin and touchID framework"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Maximo Beux" => 'mebeux@hotmail.com' }
  spec.platform = :ios, "9.1"
  spec.requires_arc = true
    spec.homepage = "https://github.com/mebeux/TouchPin"
  spec.source = { git: "https://github.com/mebeux/TouchPin.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "TouchPin/**/*.{h,swift,xib}"
end
