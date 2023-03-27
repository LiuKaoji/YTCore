//
//  UIButton+Block.h
//  YTCore
//
//  Created by kaoji on 3/14/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 定义UIButton的分类
@interface UIButton (Block)

- (void)addActionHandler:(void (^)(NSInteger tag))touchHandler;

@end

NS_ASSUME_NONNULL_END
