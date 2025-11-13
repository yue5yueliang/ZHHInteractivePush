Pod::Spec.new do |s|
  s.name             = 'ZHHInteractivePush'
  s.version          = '0.0.1'
  s.summary          = '为 UINavigationController 提供便捷的左滑交互式 push 能力'

  s.description      = <<-DESC
ZHHInteractivePush 为基于 UINavigationController 的应用带来自然顺滑的左滑 push 体验。
通过一个分类即可开启交互式转场，支持手势冲突处理、进度更新以及自定义动画委托。
适合需要在手势交互上提供更丰富体验的纯 Objective-C 项目或混编项目使用。
  DESC
  s.homepage         = 'https://github.com/yue5yueliang/ZHHInteractivePush'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHInteractivePush.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.requires_arc = true
  s.default_subspec  = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'ZHHInteractivePush/Classes/**/*'
    core.public_header_files = 'ZHHInteractivePush/Classes/**/*.h'
    core.frameworks = 'UIKit'
  end
end
