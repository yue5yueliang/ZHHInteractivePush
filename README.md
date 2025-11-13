# ZHHInteractivePush

为 `UINavigationController` 带来自然顺滑的左滑交互式 push 动画，只需一个分类即可启用。库内包含完善的手势冲突处理、动画代理封装与示例工程，便于快速集成和调试。

## 功能亮点

- 左滑即可触发交互式 push，体验与系统右滑 pop 保持一致
- 自定义 `UIPercentDrivenInteractiveTransition`，支持手势进度同步
- 自动处理 `UIScrollView` 手势冲突，避免影响列表滑动
- 完整示例工程展示交互效果与常规 push 的差异

## 安装

项目支持 iOS 13.0 及以上系统，使用 CocoaPods 一键引入：

```ruby
pod 'ZHHInteractivePush', '~> 0.0.1'
```

执行 `pod install` 或 `pod update` 即可完成集成。

## 快速上手

1. 在 `AppDelegate` 中创建导航控制器，并启用交互式 push：

```objective-c
#import <ZHHInteractivePush/UINavigationController+ZHHInteractivePush.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    ZHHViewController *root = [[ZHHViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:root];

    __weak typeof(root) weakRoot = root;
    [nav zhh_enableInteractivePushWithHandler:^UIViewController * _Nonnull{
        return [weakRoot zhh_nextPushViewController];
    }];

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}
```

2. 在需要提供下一个页面的控制器中实现 `zhh_nextPushViewController`，返回待 push 的目标控制器即可。

## 示例工程

仓库附带 `Example` 目录，可直接体验效果：

1. `git clone` 项目
2. 进入 `Example` 目录执行 `pod install`
3. 打开 `ZHHInteractivePush.xcworkspace`，运行 `ZHHInteractivePush-Example` scheme

首页支持手动按钮 push 与左滑交互式 push，方便比较两种动画体验。

## 作者

- 桃色三岁

## 许可

项目基于 MIT License 开源，详情见仓库中的 `LICENSE` 文件。
