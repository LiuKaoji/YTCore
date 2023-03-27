//
//  YTReachability.h
//  Example
//
//  Created by kaoji on 3/13/23.
//


#import <Foundation/Foundation.h>

typedef void (^YTNetworkCheckCompletion)(BOOL reachable);

@interface YTReachability : NSObject

+ (instancetype)shared;

- (void)checkWithURLString:(NSString *)urlString completion:(YTNetworkCheckCompletion)completion;

@end
