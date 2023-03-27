//
//  YTParseInfo.m
//  YTCore
//
//  Created by kaoji on 3/13/23.
//

#import "YTParseInfo.h"

@implementation Thumbnails


@end

@implementation Formats


@end

@implementation Requested_formats

@end

@implementation YTParseInfo

// 二级映射
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"formats":[Formats class]};
}

@end
