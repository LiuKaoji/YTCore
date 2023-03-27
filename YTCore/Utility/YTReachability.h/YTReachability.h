//
//  YTReachability.h
//  Example
//
//  Created by kaoji on 3/13/23.
//


#import <Foundation/Foundation.h>

// 定义一个用于处理网络连通性结果的Block
typedef void (^YTReachabilityBlock)(BOOL reachable, NSInteger code);

// YTReachability类用于检查给定URL的网络连通性
@interface YTReachability : NSObject

// 返回单例对象以便在整个应用程序中使用
+ (instancetype)shared;

// 根据给定的URL字符串检查网络连通性，并在完成时调用completion block
- (void)checkWithURLString:(NSString *)urlString completion:(YTReachabilityBlock)completion;

@end
