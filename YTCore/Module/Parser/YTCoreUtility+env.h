//
//  YTCoreUtility+env.h
//  YTCore
//
//  Created by kaoji on 3/24/23.
//

#import "YTCoreUtility.h"

NS_ASSUME_NONNULL_BEGIN

// 这个类别扩展了YTCoreUtility类，用于处理加载和销毁Python环境
@interface YTCoreUtility (env)

// 这个方法用于初始化Python
- (void)prepare;

// 这个方法用于析构Python环境
- (void)destroy;

@end


NS_ASSUME_NONNULL_END
