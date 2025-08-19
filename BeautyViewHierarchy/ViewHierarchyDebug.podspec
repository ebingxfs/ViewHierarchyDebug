Pod::Spec.new do |s|
  s.name             = 'ViewHierarchyDebug'
  s.version          = '0.1.0'
  s.summary          = '一个用于调试视图层次结构的工具'
  s.description      = <<-DESC
  ViewHierarchyDebug是一个用于iOS应用程序的视图层次结构调试工具。
  它允许开发者在运行时检查和分析视图层次结构，帮助解决布局和UI相关问题。
                       DESC

  s.homepage         = 'https://github.com/ebingxfs/ViewHierarchyDebug'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ebingxfs' => 'your-email@example.com' }
  s.source           = { :git => 'https://github.com/ebingxfs/ViewHierarchyDebug.git', :tag => s.version.to_s }
  # 本地开发时可以使用以下配置
  # s.source           = { :path => '.' }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'ViewHierarchyDebug/Classes/**/*.swift'
  
  s.dependency 'SnapKit', '~> 5.0.0'
  
  s.frameworks = 'UIKit'
end