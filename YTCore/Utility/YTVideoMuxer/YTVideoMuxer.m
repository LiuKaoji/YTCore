//
//  YTMixer.m
//  YTCore
//
//  Created by kaoji on 3/12/20.
//

#import "YTVideoMuxer.h"
#import <AVFoundation/AVFoundation.h>
#import <DLMediaUtils/DLMediaUtils.h>

@implementation YTMuxModel


@end

@implementation YTVideoMuxer

-(void)mergeVideo:(YTMuxModel *)model completion:(void (^)(NSURL *outputURL, BOOL success, NSError *error))completionBlock progress:(void (^)(CGFloat progress))progressBlock{
    
    // 启动LOG线程
    [MediaUtils runLogThread];
    
    /// 将无声mp4与aac音轨合并组成有声视频
    /// 比如youtube很多音视频就是需要分轨下载 需要对视频和音频合并才得到完整文件
    [MediaUtils muxMp4WithVideo: model.videoPath Audio: model.audioPath to: model.outputPath Complete:^(NSInteger code) {
       
        // 合并失败
        if (code != 0) {
            NSError *error = [NSError errorWithDomain:@"com.YTCore.video-merger" code:0 userInfo:@{NSLocalizedDescriptionKey: @"merge error."}];
            if(completionBlock) { completionBlock(nil, NO, error);}
            return;
        }
        
        // merge是copy流 非常快 进度几乎可以忽略
        if(progressBlock) { progressBlock(100);}
        
        // 0.25秒后回调合并结果
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSURL *outputURL = [NSURL fileURLWithPath: model.outputPath];
            if(completionBlock) { completionBlock(outputURL, YES, nil);}
        });
    }];
    
}

@end
