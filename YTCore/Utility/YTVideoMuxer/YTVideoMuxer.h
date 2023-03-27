//
//  YTMixer.h
//  YTCore
//
//  Created by kaoji on 3/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 合并音视频轨道所需的数据模型
@interface YTMuxModel : NSObject

@property (nonatomic, strong) NSString *videoPath; // 需要合并的视频轨道
@property (nonatomic, strong) NSString *audioPath; // 需要合并的音频轨
@property (nonatomic, strong) NSString *outputPath; // 合并后的输出路径

@end

/// 视频合并器，用于合并音频和视频轨道
@interface YTVideoMuxer : NSObject

/**
 合并音频和视频轨道

 @param model 合并所需的数据模型
 @param completionBlock 合并完成后的回调
 @param progressBlock 合并过程中的进度回调
 */
- (void)mergeVideo:(YTMuxModel *)model
         completion:(void (^)(NSURL *outputURL, BOOL success, NSError *error))completionBlock
          progress:(void (^)(CGFloat progress))progressBlock;

@end

NS_ASSUME_NONNULL_END
