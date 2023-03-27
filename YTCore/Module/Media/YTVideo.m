//
//  YTVideo.m
//  YTCore
//
//  Created by kaoji on 3/12/20.
//

#import "YTVideo.h"
#import "YTFileManager.h"
#import "YTParseInfo.h"
#import "YTCoreDef.h"
#import "YYModel.h"

@implementation YTVideo


@end

@implementation YTVideoListModel

+(YTVideoListModel *)parseMediaWithJSONStr:(NSString *)jsonStr andSource:(NSString *)source {
    #ifdef DEBUG
        // DEBUG模式写入本地
        NSString *jsonFilePath = [DOC_PATH stringByAppendingPathComponent:@"parse.json"];
        [YTFileManager deleteFileAtPath:jsonFilePath];
        [jsonStr writeToFile:jsonFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    #endif
    
    if (![YTVideoListModel isValidJSONString: jsonStr]) {
        return nil;
    }
    
    
    // JSON解释
    YTParseInfo *exactModel = [YTParseInfo yy_modelWithJSON: jsonStr];
    
    // 拼接所需数据
    YTVideoListModel *trackList = [[YTVideoListModel alloc] init];
    trackList.title = exactModel.title;
    trackList.thumbnail = exactModel.thumbnail;
    trackList.duration = SecondsToTimeString(exactModel.duration);
    trackList.sourceLink = source;

    // 找出音频轨道合集
    NSMutableArray *audioArray = [NSMutableArray array];
    for (Formats *trackFormat in exactModel.formats) {
        if ([trackFormat.vcodec isEqualToString:@"none"] && ![trackFormat.acodec isEqualToString:@"none"] && [trackFormat.ext isEqualToString:@"m4a"]) {
            [audioArray addObject:trackFormat];
        }
    }

    // 找出音频质量最好的轨道
    Formats *maxAudioModel = nil;
    for (Formats *trackFormat in audioArray) {
        if (!maxAudioModel || trackFormat.filesize > maxAudioModel.filesize) {
            maxAudioModel = trackFormat;
        }
    }

    NSMutableArray *videoArray = [NSMutableArray array];
    for (Formats *trackFormat in exactModel.formats) {
        
        // 非MP4格式不处理
        if (![trackFormat.ext isEqualToString:@"mp4"]){
            continue;
        }
        
        // 没找到音轨 视频不完整 略过
        if ([trackFormat.acodec isEqualToString:@"none"] && maxAudioModel == nil){
            continue;
        }
        
        // 编码器有些不兼容quicktime
        // 支持的编码器 avc1.64002a avc1.4d401f...
        // 不支持的有 av01.0.05M.08 av01.0.04M.08 av01.0.01M.08 @"av01.0.00M.08...
        // 不同的链接有多种不同编码器
        // 当前设备是否兼容AV1硬件解码 此方法并不完美 因为AV1都多种配置 并不都兼容
        // 过滤掉AV1编码格式 iPhone14 pro iOS16.1.2 测试后都不兼容
        if ([trackFormat.vcodec hasPrefix:@"av01"]){
            continue;
        }

        YTVideo *track = [[YTVideo alloc] init];
        track.resolution = [NSString stringWithFormat: @"%@ x %@", trackFormat.width, trackFormat.height];
        track.size = FILE_SIZE_STRING(trackFormat.filesize);
        track.duration = trackList.duration;
        track.videoLink = trackFormat.url;
        track.ext = trackFormat.ext;
        track.title = [self sanitizeFileName: trackList.title];// 文件名兼容文件系统命名规则
        track.vcodec = trackFormat.vcodec;
        track.pureVideo = YES;
        if ([track.size isEqualToString:@"0.00B"]){
            continue; /// 没有文件大小丢弃
        }
        
        // 当该轨道是纯视频轨时填充最好质量的音频下载路径
        if ([trackFormat.acodec isEqualToString:@"none"] ){
            track.audioLink = maxAudioModel.url;
            track.acodec = maxAudioModel.acodec;
            track.pureVideo = NO;
        }
        [videoArray addObject:track];
    }
    
    // 按文件大小从大到小排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"size" ascending:NO];
    NSArray *sortedArray = [videoArray sortedArrayUsingDescriptors:@[sortDescriptor]];

    trackList.tracks = sortedArray;
    return trackList;
    
}


+ (NSString *)sanitizeFileName:(NSString *)fileName {
    NSString *pattern = @"[\\\\/:\\*\\?\\\"<>\\|]"; // 匹配文件名中不允许的字符
    NSString *replacement = @"_"; // 替换为 ""
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *filteredFileName = [regex stringByReplacingMatchesInString:fileName options:0 range:NSMakeRange(0, fileName.length) withTemplate:replacement];
    
    return filteredFileName;
}

+ (BOOL)isValidJSONString:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return NO;
    }
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (!jsonObject || ![jsonObject isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    return YES;
}

-(NSString *)parseDescription{
    NSMutableString *desc = [[NSMutableString alloc] init];
    [desc appendFormat:@"title: %@\n", _title];
    [desc appendFormat:@"duration: %@\n", _duration];
    for (YTVideo *track in self.tracks){
        [desc appendFormat: @"%@ ---> %@",track.resolution, track.size];
    }
    return desc;
}

@end
