//
//  YTPanel.h
//  YTCore
//
//  Created by kaoji on 3/12/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YTVideo.h"

NS_ASSUME_NONNULL_BEGIN
@interface YTPanel : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy) MediaClickBlock trackCallback;


- (instancetype)initWithFrame:(CGRect)frame list:(YTVideoListModel *)trackList;

- (void)presentFromBottom;
- (void)dismissToBottom;
@end

NS_ASSUME_NONNULL_END
