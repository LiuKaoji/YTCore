//
//  NSString+Youtube.m
//  Example
//
//  Created by kaoji on 3/28/23.
//

#import "NSString+Youtube.h"

@implementation NSString (Youtube)
+ (NSString *)getYouTubeURLFromVideoKey:(NSString *)videoKey {
    if (!videoKey || [videoKey isEqualToString:@""]) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", videoKey];
}

// 从YT网址中提取videoId
+ (NSString *)getYouTubeVideoKeyFromURL:(NSString *)urlString {
    NSError *error = NULL;
    
    // 创建正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=watch\\?v=|/videos/|embed\\/)[^#\\&\\?]*" options:NSRegularExpressionCaseInsensitive error:&error];
    
    // 匹配视频 key
    NSTextCheckingResult *match = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
    
    // 返回视频 key
    if (match) {
        NSString *videoKey = [urlString substringWithRange:match.range];
        return [self getYouTubeURLFromVideoKey:videoKey];
    } else {
        return nil;
    }
}
@end
