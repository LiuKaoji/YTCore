//
//  YTPanelHead.h
//  YTCore
//
//  Created by kaoji on 3/14/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YTCornerImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTPanelHead : UIView

@property (nonatomic, strong) YTCornerImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *durationLabel;

- (instancetype)initWithFrame:(CGRect)frame imageURL:(NSURL *)imageURL title:(NSString *)title subtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
