/*
* Module:   YTCoreUtility @ YTCore
*
* Function:  主要程序功能入口,具体实现请参考调用对应分类
*
* Version: 1.0.0
*/

#import <Foundation/Foundation.h>
#import "YTCoreProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTCoreUtility : NSObject

/// 是否已配置Python环境
@property (nonatomic, assign) BOOL isPythonReady;

/// 代理
@property (nonatomic, weak) id<YTCoreDelegate> delegate;

/// 初始化资源
- (void)setup;

/// 释放资源
- (void)tearDown;

/// 更新依赖库
- (void)update;

/// 检查连接连接
- (void)checkConnection;

/// 解析视频
///
/// 需要在 调用 setup 之后 调用
/// @param urlString  youtuebe视频播放页链接
/// @param isShow   是否显示下载选择界面, 如果NO 请遵循YTCoreProtocol的didParseJSON/didParseList
- (void)parseVideoWithURLString:(NSString *)urlString showPanel:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
