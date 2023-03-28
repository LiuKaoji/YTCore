//
//  UIButton+BackgroundColor.h
//  Example
//
//  Created by kaoji on 3/21/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (BackgroundColor)
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
