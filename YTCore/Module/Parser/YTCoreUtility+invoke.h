//
//  YTCoreUtility+invoke.h
//  YTCore
//
//  Created by kaoji on 3/24/23.
//

#import "YTCoreUtility.h"
#import "YTVideo.h"
#import "YTStatus.h"

NS_ASSUME_NONNULL_BEGIN
// 这个类别扩展了YTCoreUtility类，用于处理各种回调。
@interface YTCoreUtility (invoke)

// 这个方法用于提示回调，传递YTStatus枚举值和原因字符串。
-(void)invokeMessage:(YTStatus)status reason:(NSString *)reason;

// 这个方法用于进度回调，传递JSON字符串。
-(void)invokeParseJSON:(NSString *)jsonString;

// 这个方法用于回调已解析的视频列表。
-(void)invokeParseList:(YTVideoListModel *)list;

// 这个方法用于回调已下载的视频文件的URL。
-(void)invokeDownloadedVideo:(NSURL *)url;

@end
NS_ASSUME_NONNULL_END
