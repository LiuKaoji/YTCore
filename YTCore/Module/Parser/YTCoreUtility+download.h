//
//  YTCoreUtility+download.h
//  YTCore
//
//  Created by kaoji on 3/25/23.
//

#import "YTCoreUtility.h"
#import "YTVideo.h"
#import "YTDownloader.h"
#import "YTVideoMuxer.h"
#import "YTMediaDownloadView.h"


NS_ASSUME_NONNULL_BEGIN

// 这个类别扩展了YTCoreUtility类，以添加一个新的方法并符合YTDownloadDelegate协议。
@interface YTCoreUtility (download)<YTDownloadDelegate>

// 这些是YTCoreUtility类的属性，用于下载视频。
// 它们包括muxModel，downloadModel，downloader，downloadView和用于是否已下载视频和音频的布尔值。
@property (nonatomic, strong) YTMuxModel *muxModel;
@property (nonatomic, strong) YTVideo *downloadModel;
@property (nonatomic, strong) YTDownloader *downloader;
@property (nonatomic, strong) YTMediaDownloadView *downloadView;
@property (nonatomic, assign) BOOL isVideoDownloaded;
@property (nonatomic, assign) BOOL isAudioDownloaded;

// 此方法用于下载所选视频。
-(void)downloadSelectedVideo: (YTVideo *)video;

@end

NS_ASSUME_NONNULL_END
