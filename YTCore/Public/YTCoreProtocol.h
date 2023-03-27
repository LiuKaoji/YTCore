/*
* Module:   YTCoreProtocol @ YTCore
*
* Function: YTCore 内部接口状态回调
*
* Version: 1.0.0
*/

#import <Foundation/Foundation.h>
#import "YTStatusInfo.h"
#import "YTVideo.h"

/// 这个协议定义了YTCoreDelegate代理的可选方法，用于处理各种事件。
@protocol YTCoreDelegate <NSObject>

@optional

/// 这个方法用于处理YTCore框架的运行状态，
/// @param info   状态结构体
-(void)onMessageEvent:(YTStatusInfo *_Nonnull)info;

@optional

/// 这个方法用于处理脚本返回的JSON字符串。
/// @param jsonStr   youtube_dl返回的结构体
-(void)didParseJSON:(NSString *_Nonnull)jsonStr;

/// 这个方法用于处理经过解析过滤的视频模型。
-(void)didParseList:(YTVideoListModel *_Nonnull)list;

/// 这个方法用于处理视频下载完成事件，传递视频文件的URL。
-(void)didDownloadVideo:(NSURL *_Nonnull)fileURL;

@end

