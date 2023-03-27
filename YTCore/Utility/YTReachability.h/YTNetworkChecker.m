//
//  YTReachability.m
//  Example
//
//  Created by kaoji on 3/13/23.
//

#import "YTReachability.h"

@implementation YTReachability

+ (instancetype)shared {
    static YTReachability *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YTReachability alloc] init];
    });
    return instance;
}

- (void)checkWithURLString:(NSString *)urlString completion:(YTNetworkCheckCompletion)completion {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 10.0;
    request.HTTPMethod = @"HEAD";
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error == nil && [(NSHTTPURLResponse *)response statusCode] == 200);
            });
        }
    }] resume];
}

@end
