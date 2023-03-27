//
//  YTMediaDownloadView.h
//  YTCore
//
//  Created by kaoji on 3/15/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// YTProgressView 类用于创建一个分段的进度视图
@interface YTProgressView : UIView

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;

@property (nonatomic, readwrite) NSUInteger segmentsCount;
@property (nonatomic, assign) BOOL autoFillPreviousSegments;

@property (nonatomic, strong) UIColor *trackTintColor;
@property (nonatomic, strong) UIColor *progressTintColor;

// 设置指定分段的进度
- (void) setProgress:(CGFloat)progress ForSegment:(NSUInteger)segmentIndex;

// 获取指定分段的进度
- (CGFloat)progressForSegment:(NSUInteger)segmentIndex;

@end

/// YTMediaDownloadView 类用于创建媒体下载视图，包含进度视图和其他 UI 元素
@interface YTMediaDownloadView : UIView

@property (nonatomic, strong) YTProgressView *progressView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bottomHintLabel;
@property (nonatomic, strong) UILabel *warningLabel;
@property (nonatomic, strong) UIButton *cancelButton;

// 设置进度条个数
- (void)setProgressCount:(int)count;

// 设置视频下载进度
- (void)setVideoProgress:(float)progress;

// 设置音频下载进度
- (void)setAudioProgress:(float)progress;

// 设置合并进度
- (void)setMergeProgress:(float)progress;

// 全局显示
-(void)showInWindow;

// 隐藏
-(void)dismissFromWindow;

@end

NS_ASSUME_NONNULL_END

