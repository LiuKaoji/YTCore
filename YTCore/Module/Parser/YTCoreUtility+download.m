//
//  YTCoreUtility+download.m
//  YTCore
//
//  Created by kaoji on 3/25/23.
//

#import "YTCoreUtility+download.h"
#import "YTCoreUtility+invoke.h"
#import <objc/runtime.h>
#import "YTCoreDef.h"
#import "YTFileManager.h"
#import "UIButton+Block.h"

@implementation YTCoreUtility (download)
@dynamic downloader;
@dynamic muxModel;
@dynamic downloadModel;
@dynamic isVideoDownloaded;
@dynamic isAudioDownloaded;

// 下载器
- (void)setDownloader:(YTDownloader *)downloader {
    objc_setAssociatedObject(self, @selector(downloader), downloader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YTDownloader *)downloader {
    return objc_getAssociatedObject(self, @selector(downloader));
}

// 混合音视频
- (void)setMuxModel:(YTMuxModel *)muxModel {
    objc_setAssociatedObject(self, @selector(muxModel), muxModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YTMuxModel *)muxModel {
    return objc_getAssociatedObject(self, @selector(muxModel));
}

// 待下载模型
- (void)setDownloadModel:(YTVideo *)downloadModel {
    objc_setAssociatedObject(self, @selector(downloadModel), downloadModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YTVideo *)downloadModel {
    return objc_getAssociatedObject(self, @selector(downloadModel));
}

// 待下载模型
- (void)setDownloadView:(YTMediaDownloadView *)downloadView {
    objc_setAssociatedObject(self, @selector(downloadView), downloadView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YTMediaDownloadView *)downloadView {
    return objc_getAssociatedObject(self, @selector(downloadView));
}

//是否完成视频下载
- (BOOL)isVideoDownloaded {
    return [objc_getAssociatedObject(self, @selector(isVideoDownloaded)) boolValue];
}

- (void)setIsVideoDownloaded:(BOOL)isVideoDownloaded {
    objc_setAssociatedObject(self, @selector(isVideoDownloaded), @(isVideoDownloaded), OBJC_ASSOCIATION_ASSIGN);
}

//是否完成音频下载
- (BOOL)isAudioDownloaded {
    return [objc_getAssociatedObject(self, @selector(isAudioDownloaded)) boolValue];
}

- (void)setIsAudioDownloaded:(BOOL)isAudioDownloaded {
    objc_setAssociatedObject(self, @selector(isAudioDownloaded), @(isAudioDownloaded), OBJC_ASSOCIATION_ASSIGN);
}



-(void)downloadSelectedVideo: (YTVideo *)video{
    
    self.downloadModel = video;
    
    NSString *saveName = [NSString stringWithFormat:@"%@.%@", self.downloadModel.title, self.downloadModel.ext];
    self.muxModel = [[YTMuxModel alloc] init];
    self.muxModel.videoPath =  [TEMP_PATH stringByAppendingPathComponent: @"TEMP_VIDEO.mp4"];
    self.muxModel.audioPath =  [TEMP_PATH stringByAppendingPathComponent: @"TEMP_AIDEO.m4a"];
    self.muxModel.outputPath = [DOC_PATH stringByAppendingPathComponent: saveName];
    
    [YTFileManager deleteFileAtPath: self.muxModel.videoPath ];
    [YTFileManager deleteFileAtPath: self.muxModel.audioPath];
    
    [self showStatusView];
    [self processDownloadAction];
}

-(void)showStatusView{
    self.downloadView = [[YTMediaDownloadView alloc] init];
    self.downloadView .titleLabel.text = self.downloadModel.title;
    
    int count = self.downloadModel.pureVideo ?1:3;
    [self.downloadView  setProgressCount: count];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.downloadView showInWindow];
    });
    
    __weak typeof(self) weakSelf = self;
    [self.downloadView.cancelButton addActionHandler:^(NSInteger tag) {
        [weakSelf cancel];
    }];
}

-(void)processDownloadAction{
    // 都没下载
    if (!self.isVideoDownloaded && !self.isAudioDownloaded){
        [self startDownloadVideo];
        return;
    }
    
    // 是纯视频且视频已经下载完成
    if (self.isVideoDownloaded && self.downloadModel.pureVideo){
        // 回调视频
        [self invokeMessage: YTProcess reason: [NSString stringWithFormat:@"正在移动: \n%@ 视频文件至: %@",self.muxModel.videoPath, self.muxModel.outputPath]];
        __weak typeof(self) weakSelf = self;
        [YTFileManager moveFileFrom: self.muxModel.videoPath to:self.muxModel.outputPath completion:^(BOOL success, NSError * _Nonnull error) {
            if(error){
                [weakSelf invokeMessage:YTMediaDLError reason:@"文件移动失败"];
            }else{
                NSURL *fileURL = [NSURL fileURLWithPath: weakSelf.muxModel.videoPath];
                [weakSelf invokeMessage:YTMediaDLOk reason:@"文件移动成功"];
                [weakSelf invokeDownloadedVideo: fileURL];
            }
            [weakSelf.downloadView dismissFromWindow];
        }];
        return;
    }
    
    // 下载了视频, 开始下载音频
    if (self.isVideoDownloaded && !self.isAudioDownloaded){
        [self startDownloadAudio];
    }
    
    // 下载了视频和音频
    if (self.isVideoDownloaded && self.isAudioDownloaded){
        [self startMuxMedias];// 开始混合并回调视频合并结果
    }
}

// 下载视频频
-(void)startDownloadVideo{
    // 创建下载内容
    NSURL *videoURL = [NSURL URLWithString: self.downloadModel.videoLink];
    NSURL *dstURL = [NSURL fileURLWithPath: self.muxModel.videoPath];
    self.downloader = [[YTDownloader alloc] init];
    self.downloader.delegate = self;
    [self.downloader startDownloadWithURL: videoURL toDestination: dstURL];
    
    [self invokeMessage: YTProcess reason: [NSString stringWithFormat:@"正在从: \n%@ \n下载视频文件至: \n%@",videoURL, dstURL]];
}

// 下载音频
-(void)startDownloadAudio{
    
    // 创建下载内容;
    NSURL *audioURL = [NSURL URLWithString: self.downloadModel.audioLink];
    NSURL *dstURL = [NSURL fileURLWithPath: self.muxModel.audioPath];
    self.downloader = [[YTDownloader alloc] init];
    self.downloader.delegate = self;
    [self.downloader startDownloadWithURL: audioURL toDestination: dstURL];
    
    [self invokeMessage: YTProcess reason: [NSString stringWithFormat:@"正在从: \n%@ \n 下载音频文件至: %@",audioURL, dstURL]];
}

-(void)didReceiveError:(NSError *)error{
    [self invokeMessage:YTMediaDLError reason: error.localizedDescription];
}

-(void)didReceiveDownloadURL:(NSURL *)downloadURL{
    if([YTFileManager fileExistsAtPath: downloadURL.path]){
        if(!self.isVideoDownloaded){
            self.isVideoDownloaded = YES;
        }else{
            self.isAudioDownloaded = YES;
        }
        [self processDownloadAction];
    }else {
        [self processDownloadAction];
    }
}

-(void)didReceiveDownloadSize:(NSString *)size withProgress:(CGFloat)progress{
    BOOL isVideo = (!self.isVideoDownloaded);
    NSString *typeStr = isVideo ?@"加载视频":@"加载音频";
    NSString *desc = [NSString stringWithFormat:@"%@(%@)", typeStr, size];
    
    // 更新提示文本
    self.downloadView.bottomHintLabel.text = desc;
    
    //更新进度条
    isVideo ?[self.downloadView setVideoProgress: progress]:[self.downloadView setAudioProgress: progress];
    
    // 代理回调
    [self invokeMessage:YTMediaDLProgress reason: desc];
}


-(void)startMuxMedias{
    
    [self invokeMessage: YTProcess reason: [NSString stringWithFormat:@"正在合并音视频: \n视频源: %@ \n音频源: %@ \n输出路径: %@",self.muxModel.videoPath, self.muxModel.audioPath, self.muxModel.outputPath]];
    
    YTVideoMuxer *muxer = [[YTVideoMuxer alloc] init];
    __weak typeof(self) weakSelf = self;
    [YTFileManager deleteFileAtPath: self.muxModel.outputPath];
    [muxer mergeVideo: self.muxModel completion:^(NSURL * _Nonnull outputURL, BOOL success, NSError * _Nonnull error) {
        
        if (success){
            [weakSelf invokeMessage:YTMediaDLOk reason:@"合流成功"];
            [weakSelf invokeDownloadedVideo: outputURL];
        }else{
            [weakSelf invokeMessage:YTMediaDLOk reason:@"合流成功"];
            [weakSelf invokeDownloadedVideo: outputURL];
        }
        
        dispatch_async(MAIN_QUEUE, ^{
            [weakSelf.downloadView dismissFromWindow];
        });
        
    } progress:^(CGFloat progress) {
        NSLog(@"正在合并视频, 进度: %.2f", progress);
        [weakSelf.downloadView setMergeProgress: progress];
    }];
}

-(void)cancel{
    
    [self.downloader.session invalidateAndCancel];
    
    [YTFileManager deleteFileAtPath: self.muxModel.videoPath];
    [YTFileManager deleteFileAtPath: self.muxModel.audioPath];
    
    dispatch_async(MAIN_QUEUE, ^{
        [self.downloadView dismissFromWindow];
    });
}

@end
