//
//  YTDownloader.h
//  YTCore
//
//  Created by kaoji on 3/22/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// YTDownloadDelegate 协议定义了下载过程中的代理回调方法
@protocol YTDownloadDelegate <NSObject>

@optional
- (void)didReceiveError:(NSError *)error; // 收到错误时的回调
- (void)didReceiveDownloadURL:(NSURL *)downloadURL; // 收到下载链接时的回调
- (void)didReceiveDownloadSize:(NSString *)size withProgress:(CGFloat)progress; // 收到下载大小及进度时的回调

@end

// 定义回调 Block 类型
typedef void (^YTDownloaderErrorBlock)(NSError *error);
typedef void (^YTDownloaderDownloadURLBlock)(NSURL *downloadURL);
typedef void (^YTDownloaderDownloadSizeBlock)(NSString *size, CGFloat progress);

/// YTDownloader 类负责处理视频下载任务
@interface YTDownloader : NSObject <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session; // 下载会话

@property (nonatomic, weak) id<YTDownloadDelegate> delegate; // YTDownloadDelegate 协议回调

// Block 回调
@property (nonatomic, copy, nullable) YTDownloaderErrorBlock errorBlock;
@property (nonatomic, copy, nullable) YTDownloaderDownloadURLBlock downloadURLBlock;
@property (nonatomic, copy, nullable) YTDownloaderDownloadSizeBlock downloadSizeBlock;

/**
 开始下载视频

 @param srcURL 源视频 URL
 @param dstURL 下载目标文件 URL
 */
- (void)startDownloadWithURL:(NSURL *)srcURL toDestination:(NSURL *)dstURL;

@end

NS_ASSUME_NONNULL_END

