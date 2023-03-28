//
//  YTPanel.m
//  YTCore
//
//  Created by kaoji on 3/12/20.
//

#import "YTPanel.h"
#import "YTPanelTable.h"
#import "YTPanelHead.h"

@interface YTPanel()
@property (nonatomic, strong) YTPanelHead *panelHead;
@end

@implementation YTPanel
{
    YTPanelTable *_table;
}
- (instancetype)initWithFrame:(CGRect)frame list:(YTVideoListModel *)trackList {
    if (self = [super initWithFrame:frame]){
        [self initPanel: trackList];
    }
    return self;
}

- (void)initPanel: (YTVideoListModel *)trackList {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow == nil) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    
    // 添加黑色半透明背景
    self.backgroundView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [keyWindow addSubview:self.backgroundView];
    
    // 添加弹出视图
    CGFloat contentHeight = 350.0; // 以200.0为例
    CGFloat screenWidth = CGRectGetWidth(keyWindow.bounds);
    CGFloat contentWidth = screenWidth;
    CGFloat contentX = 0.0;
    CGFloat contentY = CGRectGetHeight(keyWindow.bounds);
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(contentX, contentY, contentWidth, contentHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [keyWindow addSubview:self.contentView];
    
    
    // 创建 YTPanelHead
    
    NSURL *imageURL = [NSURL URLWithString:trackList.thumbnail];
    NSString *title = trackList.title;
    NSString *subTitle = trackList.duration;
    _panelHead = [[YTPanelHead alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100) imageURL:imageURL title:title subtitle:subTitle];
    [self.contentView addSubview:_panelHead];
    
    // 创建 YTPanelTable
    __weak typeof(self) weakSelf = self;
    _table = [[YTPanelTable alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.trackCallback = ^(YTVideo * _Nonnull track){
        if(weakSelf.trackCallback){
            weakSelf.trackCallback(track);
        }
    };
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [_table configWithModel: trackList];
    [self.contentView addSubview:_table];
    
    // 底部安全高度
    CGFloat bottomSafeAreaHeight = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        bottomSafeAreaHeight = window.safeAreaInsets.bottom;
    }
    
    // 添加约束
    [NSLayoutConstraint activateConstraints:@[
        // YTPanelHead约束
        [_panelHead.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [_panelHead.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [_panelHead.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [_panelHead.heightAnchor constraintEqualToConstant:100.0],
        
        // YTPanelTable约束
        [_table.topAnchor constraintEqualToAnchor:_panelHead.bottomAnchor],
        [_table.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [_table.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [_table.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant: -bottomSafeAreaHeight],
    ]];
    
    
    // 添加手势，支持下滑关闭弹出视图
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.backgroundView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.backgroundView addGestureRecognizer:tapGesture];
    
    [keyWindow bringSubviewToFront:self];
    [keyWindow bringSubviewToFront:_backgroundView];
    [keyWindow bringSubviewToFront:_contentView];
}

- (void)presentFromBottom {
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(contentFrame);
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = contentFrame;
    }];
}

- (void)dismissToBottom {
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.y = CGRectGetHeight(self.bounds);
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = contentFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backgroundView removeFromSuperview];
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.y += translation.y;
    if (contentFrame.origin.y < CGRectGetHeight(self.bounds) - CGRectGetHeight(contentFrame)) {
        contentFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(contentFrame);
    }
    if (contentFrame.origin.y > CGRectGetHeight(self.bounds)) {
        contentFrame.origin.y = CGRectGetHeight(self.bounds);
    }
    self.contentView.frame = contentFrame;
    [gesture setTranslation:CGPointZero inView:self];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [gesture velocityInView:self];
        if (velocity.y > 0) {
            [self dismissToBottom];
        } else {
            [self presentFromBottom];
        }
    }
}

- (void)handleTap:(UIPanGestureRecognizer *)gesture {
    [self dismissToBottom];
}
@end
