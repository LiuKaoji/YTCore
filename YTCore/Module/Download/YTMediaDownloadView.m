//
//  YTMediaDownloadView.m
//  YTCore
//
//  Created by kaoji on 3/15/23.
//

#import "YTMediaDownloadView.h"
#import "YTCoreDef.h"

@implementation YTProgressView{
  NSMutableArray <UIProgressView *> *_progressViews;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.autoFillPreviousSegments = YES;
    self.trackTintColor = [UIColor darkGrayColor];
    self.progressTintColor = [UIColor whiteColor];
    self.leftMargin = 0.0f;
    self.rightMargin = 0.0f;
    self.spacing = 3.0f;
    _progressViews = [NSMutableArray array];
}

- (NSUInteger) segmentsCount {
    return _progressViews.count;
}

- (void) setSegmentsCount:(NSUInteger)segmentsCount {
    while (self.segmentsCount != segmentsCount) {
        if (segmentsCount > self.segmentsCount) {
            [_progressViews addObject:[self newProgressView]];
            [self addSubview:[_progressViews lastObject]];
        }
        else {
            [[_progressViews lastObject] removeFromSuperview];
            [_progressViews removeLastObject];
        }
    }
}

- (void) setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    for (UIProgressView *p in _progressViews) {
        p.progressTintColor = progressTintColor;
    }
}

- (void) setMediaTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    for (UIProgressView *p in _progressViews) {
        p.trackTintColor = trackTintColor;
    }
}

- (UIProgressView *) newProgressView {
    UIProgressView *result = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    result.trackTintColor = self.trackTintColor;
    result.progressTintColor = self.progressTintColor;
    return result;
}

- (void) setProgress:(CGFloat)progress ForSegment:(NSUInteger)segmentIndex {
    if (self.autoFillPreviousSegments) {
        for (int i=0; i<_progressViews.count;i++) {
            if (i < segmentIndex) {
                [[_progressViews objectAtIndex:i] setProgress:1.0f];
            }
            else if (i == segmentIndex) {
                [[_progressViews objectAtIndex:i] setProgress:progress];
            }
            else {
                break;
            }
        }
    }
    else {
        [[_progressViews objectAtIndex:segmentIndex] setProgress:progress];
    }
}

- (CGFloat) progressForSegment:(NSUInteger)segmentIndex {
    return [[_progressViews objectAtIndex:segmentIndex] progress];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat progressW = (self.frame.size.width - self.leftMargin - self.rightMargin - ([self segmentsCount]-1)*self.spacing) / self.segmentsCount;
    for (int i=0; i<self.segmentsCount;i++) {
        CGRect f = (CGRect){
            self.leftMargin + (progressW+self.spacing)*i,
            0,
            progressW,
            self.frame.size.height
        };
        [[_progressViews objectAtIndex:i] setFrame:f];
    }
}

- (void) setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    [self setNeedsLayout];
}

- (void) setRightMargin:(CGFloat)rightMargin {
    _rightMargin = rightMargin;
    [self setNeedsLayout];
}

- (void) setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    [self setNeedsLayout];
}

@end


@implementation YTMediaDownloadView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupPopUpView];
    }
    return self;
}

- (void)setupPopUpView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;

    // 创建标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];

    // 创建进度条
    self.progressView = [[YTProgressView alloc]initWithFrame: CGRectZero];
    self.progressView.trackTintColor = [UIColor grayColor];
    self.progressView.progressTintColor = [UIColor blueColor];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.progressView];

    // 创建底部提示语标签
    self.bottomHintLabel = [[UILabel alloc] init];
    self.bottomHintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomHintLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomHintLabel.font = [UIFont systemFontOfSize:13];
    self.bottomHintLabel.textColor = [UIColor darkGrayColor];
    self.bottomHintLabel.text = @"请稍后...";
    [self addSubview:self.bottomHintLabel];
    
    // 创建底部提示语标签
    self.warningLabel = [[UILabel alloc] init];
    self.warningLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.warningLabel.textAlignment = NSTextAlignmentCenter;
    self.warningLabel.font = [UIFont systemFontOfSize:12];
    self.warningLabel.textColor = [UIColor redColor];
    self.warningLabel.text = @"请勿熄屏或离开程序";
    [self addSubview:self.warningLabel];


    // 创建取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelButton.backgroundColor = [UIColor blueColor];
    self.cancelButton.layer.cornerRadius = 6;
    [self.cancelButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:self.cancelButton];
    

    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.progressView.topAnchor constant: -30],
        [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.titleLabel.heightAnchor constraintEqualToConstant: 40],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant: -20],

        [self.progressView.centerYAnchor constraintEqualToAnchor: self.centerYAnchor],
        [self.progressView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.progressView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.progressView.heightAnchor constraintEqualToConstant: 20],

        [self.bottomHintLabel.topAnchor constraintEqualToAnchor:self.progressView.bottomAnchor constant: 20],
        [self.bottomHintLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],

        [self.progressView.widthAnchor constraintEqualToConstant: 20],
        [self.progressView.heightAnchor constraintEqualToConstant: 20],
       
        [self.cancelButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.cancelButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20],
        
        [self.cancelButton.widthAnchor constraintEqualToConstant: 50],
        [self.cancelButton.heightAnchor constraintEqualToConstant: 30],
        
        [self.warningLabel.topAnchor constraintEqualToAnchor:self.bottomHintLabel.bottomAnchor constant:10],
        [self.warningLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
    ]];
}

-(void)setProgressCount:(int)count{
    self.progressView.segmentsCount = count;
}

-(void)setVideoProgress:(float)progress{
    [self.progressView setProgress:progress ForSegment:0];
    self.bottomHintLabel.text = [NSString stringWithFormat:@"下载视频流(%.2f%%)...", progress * 100.0];
}

-(void)setAudioProgress:(float)progress{
    [self.progressView setProgress:progress ForSegment:1];
    self.bottomHintLabel.text = [NSString stringWithFormat:@"下载音频流(%.2f%%)...", progress * 100.0];
}

-(void)setMergeProgress:(float)progress{
    [self.progressView setProgress:progress ForSegment:2];
    self.bottomHintLabel.text = @"合并轨道...";
}

// 全局显示
-(void)showInWindow{
    UIWindow *window = FIND_KEY_WINDOW;
    [window addSubview: self];
    NSLayoutConstraint *centerXConstraint = [self.centerXAnchor constraintEqualToAnchor:window.centerXAnchor];
    NSLayoutConstraint *centerYConstraint = [self.centerYAnchor constraintEqualToAnchor:window.centerYAnchor];
    
    CGFloat widthMultiplier = 0.8;
    NSLayoutConstraint *widthConstraint = [self.widthAnchor constraintEqualToAnchor: window.widthAnchor multiplier:widthMultiplier];
    
    CGFloat aspectRatio = 4.0 / 3.0;
    NSLayoutConstraint *aspectRatioConstraint = [self.heightAnchor constraintEqualToAnchor:window.widthAnchor multiplier:1.0 / aspectRatio];
    
    [NSLayoutConstraint activateConstraints:@[centerXConstraint, centerYConstraint, widthConstraint, aspectRatioConstraint]];
    
    // 禁止设备息屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

// 隐藏
-(void)dismissFromWindow{
    [self removeFromSuperview];
    // 允许设备息屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

}
@end
