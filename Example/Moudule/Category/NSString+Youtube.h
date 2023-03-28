//
//  NSString+Youtube.h
//  Example
//
//  Created by kaoji on 3/28/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Youtube)
// 拼合网址
+ (NSString *)getYouTubeURLFromVideoKey:(NSString *)videoKey;

// 从YT网址中提取videoId
+ (NSString *)getYouTubeVideoKeyFromURL:(NSString *)urlString;
@end

NS_ASSUME_NONNULL_END
