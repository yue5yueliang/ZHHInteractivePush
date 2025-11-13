//
//  ZHHViewController.m
//  ZHHInteractivePush
//
//  Created by 桃色三岁 on 11/13/2025.
//  Copyright (c) 2025 桃色三岁. All rights reserved.
//

#import "ZHHViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHHDemoContentViewController : UIViewController

- (instancetype)initWithIndex:(NSUInteger)index backgroundColor:(UIColor *)backgroundColor NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign, readonly) NSUInteger pageIndex;

@end

@interface ZHHViewController ()

@property (nonatomic, assign) NSUInteger nextIndex;
@property (nonatomic, copy) NSArray<UIColor *> *demoColors;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation ZHHViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _nextIndex = 0;
        _demoColors = @[
            [UIColor colorWithRed:0.19f green:0.30f blue:0.70f alpha:1.0f],
            [UIColor colorWithRed:0.13f green:0.56f blue:0.43f alpha:1.0f],
            [UIColor colorWithRed:0.90f green:0.32f blue:0.36f alpha:1.0f],
            [UIColor colorWithRed:0.72f green:0.50f blue:0.94f alpha:1.0f],
            [UIColor colorWithRed:0.96f green:0.59f blue:0.17f alpha:1.0f],
            [UIColor colorWithRed:0.29f green:0.28f blue:0.31f alpha:1.0f]
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"ZHHInteractivePush 示例";
    self.view.backgroundColor = [self zhh_systemBackgroundColor];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(zhh_handleResetTapped)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"向左滑动屏幕右侧空白区域，即可体验自定义交互式 push 转场。";
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    detailLabel.numberOfLines = 0;
    detailLabel.text = @"你也可以点击下方按钮进行普通的 push，观察两者在体验上的区别。";
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeSystem];
    pushButton.translatesAutoresizingMaskIntoConstraints = NO;
    pushButton.contentEdgeInsets = UIEdgeInsetsMake(12, 32, 12, 32);
    pushButton.layer.cornerRadius = 10.0;
    pushButton.layer.masksToBounds = YES;
    pushButton.backgroundColor = [self zhh_tintColor];
    [pushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushButton setTitle:@"手动 push 一个页面" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(zhh_handlePushButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    statusLabel.numberOfLines = 0;
    self.statusLabel = statusLabel;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, detailLabel, pushButton, statusLabel]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 20.0;
    
    [self.view addSubview:stackView];
    
    UILayoutGuide *layoutGuide;
    if (@available(iOS 11.0, *)) {
        layoutGuide = self.view.safeAreaLayoutGuide;
    } else {
        layoutGuide = self.view.layoutMarginsGuide;
    }
    
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:layoutGuide.centerYAnchor],
        [stackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:layoutGuide.leadingAnchor],
        [stackView.trailingAnchor constraintLessThanOrEqualToAnchor:layoutGuide.trailingAnchor],
        [pushButton.widthAnchor constraintGreaterThanOrEqualToConstant:200.0]
    ]];
    
    [self zhh_updateStatusLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self zhh_updateStatusLabel];
}

- (UIViewController *)zhh_nextPushViewController {
    NSUInteger targetIndex = self.nextIndex + 1;
    UIColor *backgroundColor = self.demoColors[(targetIndex - 1) % self.demoColors.count];
    ZHHDemoContentViewController *viewController = [[ZHHDemoContentViewController alloc] initWithIndex:targetIndex
                                                                                      backgroundColor:backgroundColor];
    self.nextIndex = targetIndex;
    [self zhh_updateStatusLabel];
    return viewController;
}

- (void)zhh_handlePushButtonTapped:(UIButton *)sender {
    UIViewController *viewController = [self zhh_nextPushViewController];
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)zhh_handleResetTapped {
    self.nextIndex = 0;
    [self zhh_updateStatusLabel];
}

- (void)zhh_updateStatusLabel {
    if (!self.statusLabel) {
        return;
    }
    NSString *message = [NSString stringWithFormat:@"继续操作将展示第 %lu 个页面。",
                         (unsigned long)(self.nextIndex + 1)];
    self.statusLabel.text = message;
    self.statusLabel.textColor = [self zhh_secondaryLabelColor];
}

- (UIColor *)zhh_systemBackgroundColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor systemBackgroundColor];
    }
    return [UIColor whiteColor];
}

- (UIColor *)zhh_tintColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor systemBlueColor];
    }
    return [UIColor colorWithRed:0.00f green:0.48f blue:1.00f alpha:1.0f];
}

- (UIColor *)zhh_secondaryLabelColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor secondaryLabelColor];
    }
    return [UIColor colorWithWhite:0.45f alpha:1.0f];
}

@end

#pragma mark - ZHHDemoContentViewController

@interface ZHHDemoContentViewController ()

@property (nonatomic, assign, readwrite) NSUInteger pageIndex;
@property (nonatomic, strong) UIColor *backgroundTintColor;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZHHDemoContentViewController

- (instancetype)init {
    return [self initWithIndex:1 backgroundColor:[UIColor blackColor]];
}

- (instancetype)initWithIndex:(NSUInteger)index backgroundColor:(UIColor *)backgroundColor {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _pageIndex = index;
        _backgroundTintColor = backgroundColor ?: [UIColor darkGrayColor];
        self.title = [NSString stringWithFormat:@"第 %lu 个页面", (unsigned long)index];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.backgroundTintColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleLargeTitle];
    titleLabel.text = [NSString stringWithFormat:@"第 %lu 个页面", (unsigned long)self.pageIndex];
    self.titleLabel = titleLabel;
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    descriptionLabel.text = @"保持左滑即可连续 push，或者右滑返回上一页。";
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, descriptionLabel]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 16.0;
    
    [self.view addSubview:stackView];
    
    UILayoutGuide *layoutGuide;
    if (@available(iOS 11.0, *)) {
        layoutGuide = self.view.safeAreaLayoutGuide;
    } else {
        layoutGuide = self.view.layoutMarginsGuide;
    }
    
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:layoutGuide.centerYAnchor],
        [stackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:layoutGuide.leadingAnchor constant:20.0],
        [stackView.trailingAnchor constraintLessThanOrEqualToAnchor:layoutGuide.trailingAnchor constant:-20.0]
    ]];
}

@end

NS_ASSUME_NONNULL_END
