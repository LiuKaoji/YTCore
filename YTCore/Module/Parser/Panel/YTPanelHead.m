//
//  YTPanelHead.m
//  YTCore
//
//  Created by kaoji on 3/14/23.
//

#import "YTPanelHead.h"

@implementation YTPanelHead

- (instancetype)initWithFrame:(CGRect)frame imageURL:(NSURL *)imageURL title:(NSString *)title subtitle:(NSString *)subtitle {
    self = [super initWithFrame:frame];
    if (self) {
        // 创建工具条
        UIView *toolbar = [[UIView alloc] init];
        toolbar.backgroundColor = [UIColor blackColor];
        toolbar.alpha = 0.8;
        toolbar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:toolbar];
        
        // 创建毛玻璃效果的视图
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
        [toolbar addSubview:visualEffectView];
        
        // 创建缩略图、标题和时长
        self.thumbnailImageView = [[YTCornerImageView alloc] init];
        self.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.thumbnailImageView.cornerRadius = 8;
        [self addSubview:self.thumbnailImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        
        self.durationLabel = [[UILabel alloc] init];
        self.durationLabel.text = subtitle;
        self.durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.durationLabel];
        
        // 添加工具条约束
        [NSLayoutConstraint activateConstraints:@[
            [toolbar.topAnchor constraintEqualToAnchor:self.topAnchor],
            [toolbar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [toolbar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [toolbar.heightAnchor constraintEqualToConstant:44.0]
        ]];
        
        // 添加毛玻璃效果的视图约束
        [NSLayoutConstraint activateConstraints:@[
            [visualEffectView.topAnchor constraintEqualToAnchor:toolbar.topAnchor],
            [visualEffectView.leadingAnchor constraintEqualToAnchor:toolbar.leadingAnchor],
            [visualEffectView.trailingAnchor constraintEqualToAnchor:toolbar.trailingAnchor],
            [visualEffectView.bottomAnchor constraintEqualToAnchor:toolbar.bottomAnchor]
        ]];
        
        
        [NSLayoutConstraint activateConstraints:@[
            // 缩略图视图的高度等于其父视图高度的80%
            [self.thumbnailImageView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5],
            // 缩略图视图的顶部边缘等于其父视图的顶部边缘
            [self.thumbnailImageView.topAnchor constraintEqualToAnchor:toolbar.bottomAnchor constant:8.0],
            // 缩略图视图的底部边缘等于其父视图的底部边缘
            [self.thumbnailImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant: -8],
            // 缩略图宽高比
            [self.thumbnailImageView.widthAnchor constraintEqualToAnchor:self.thumbnailImageView.heightAnchor],
            // 左边距
            [self.thumbnailImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
            
            [self.titleLabel.topAnchor constraintEqualToAnchor:toolbar.bottomAnchor constant:8.0],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.thumbnailImageView.trailingAnchor constant:16.0],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0],
            
            [self.durationLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8.0],
            [self.durationLabel.leadingAnchor constraintEqualToAnchor:self.thumbnailImageView.trailingAnchor constant:16.0],
            [self.durationLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0],
            [self.durationLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8.0]
        ]];
        
        
        // 加载图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.thumbnailImageView.image = image;
            });
        });
    }
    return self;
}

@end
