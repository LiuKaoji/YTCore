//
//  YTParseInfo.h
//  YTCore
//
//  Created by kaoji on 3/13/23.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

// 该数据模型从parse.plist映射
// 本项目只获取缩略图、标题、时长、文件大小、分辨率等基础信息
// 更多详情请参阅https://github.com/ytdl-org/youtube-dl

@interface Thumbnails :NSObject
@property (nonatomic , assign) NSInteger height; // 缩略图高度
@property (nonatomic , copy) NSString * id; // 缩略图ID
@property (nonatomic , copy) NSString * url; // 缩略图URL
@property (nonatomic , copy) NSString * resolution; // 缩略图分辨率
@property (nonatomic , assign) NSInteger width; // 缩略图宽度

@end

@interface Formats :NSObject
@property (nonatomic , copy) NSString * acodec; // 音频编码
@property (nonatomic , assign) NSInteger asr; // 音频采样率
@property (nonatomic , assign) NSInteger quality; // 视频质量
@property (nonatomic , copy) NSString * vcodec; // 视频编码
@property (nonatomic , copy) NSString * protocol; // 协议
@property (nonatomic , copy) NSString * fps; // 视频帧率
@property (nonatomic , assign) NSInteger filesize; // 文件大小
@property (nonatomic , copy) NSString * width; // 视频宽度
@property (nonatomic , copy) NSString * url; // 视频URL
@property (nonatomic , assign) CGFloat tbr; // 视频比特率
@property (nonatomic , assign) CGFloat abr; // 音频比特率
@property (nonatomic , copy) NSString * format_note; // 格式说明
@property (nonatomic , copy) NSString * format; // 格式
@property (nonatomic , copy) NSString * ext; // 文件扩展名
@property (nonatomic , copy) NSString * container; // 容器格式
@property (nonatomic , copy) NSString * height; // 视频高度
@property (nonatomic , copy) NSString * format_id; // 格式ID

@end

@interface Requested_formats :NSObject
@property (nonatomic , copy) NSString * acodec; // 音频编码
@property (nonatomic , copy) NSString * asr; // 音频采样率
@property (nonatomic , assign) NSInteger quality; // 视频质量
@property (nonatomic , copy) NSString * vcodec; // 视频编码
@property (nonatomic , copy) NSString * protocol; // 协议
@property (nonatomic , assign) NSInteger fps; // 视频帧率
@property (nonatomic , assign) NSInteger filesize; // 文件大小
@property (nonatomic , assign) NSInteger width; // 视频宽度
@property (nonatomic , copy) NSString * url; // 视频URL
@property (nonatomic , assign) CGFloat tbr; // 视频比特率
@property (nonatomic , copy) NSString * format_note; // 格式说明
@property (nonatomic , copy) NSString * format; // 格式
@property (nonatomic , copy) NSString * ext; // 文件扩展名
@property (nonatomic , assign) NSInteger height; // 视频高度
@property (nonatomic , copy) NSString * container; // 容器格式
@property (nonatomic , assign) CGFloat vbr; // 音频比特率
@property (nonatomic , copy) NSString * format_id; // 格式ID

@end

// 主体
@interface YTParseInfo : NSObject
@property (nonatomic , assign) NSInteger width; // 视频宽度
@property (nonatomic , copy) NSString * playlist_index; // 播放列表索引
@property (nonatomic , copy) NSString * id; // 视频ID
@property (nonatomic , assign) CGFloat vbr; // 音频比特率
@property (nonatomic , copy) NSString * ext; // 文件扩展名
@property (nonatomic , copy) NSString * channel_url; // 频道URL
@property (nonatomic , copy) NSArray<Thumbnails *> * thumbnails; // 缩略图数组
@property (nonatomic , copy) NSString * stretched_ratio; // 缩放比例
@property (nonatomic , assign) NSInteger duration; // 视频时长
@property (nonatomic , copy) NSString * acodec; // 音频编码
@property (nonatomic , copy) NSString * playlist; // 播放列表
@property (nonatomic , copy) NSString * extractor; // 提取器
@property (nonatomic , copy) NSString * format_id; // 格式ID
@property (nonatomic , copy) NSString * channel; // 频道
@property (nonatomic , assign) NSInteger age_limit; // 年龄限制
@property (nonatomic , copy) NSString * webpage_url_basename; // 页面URL基名
@property (nonatomic , copy) NSString * thumbnail; // 缩略图
@property (nonatomic , assign) NSInteger height; // 视频高度
@property (nonatomic , copy) NSString * uploader_url; // 上传者URL
@property (nonatomic , assign) CGFloat abr; // 音频比特率
@property (nonatomic , copy) NSString * channel_id; // 频道ID
@property (nonatomic , copy) NSString * extractor_key; // 提取器Key
@property (nonatomic , copy) NSString * uploader; // 上传者
@property (nonatomic , copy) NSString * format; // 格式
@property (nonatomic , copy) NSString * requested_subtitles; // 请求的字幕
@property (nonatomic , assign) NSInteger view_count; // 观看次数
@property (nonatomic , copy) NSString * vcodec; // 视频编码
@property (nonatomic , copy) NSString * display_id; // 显示ID
@property (nonatomic , copy) NSArray<NSString *> * categories; // 分类数组
@property (nonatomic , copy) NSString * upload_date; // 上传日期
@property (nonatomic , copy) NSString * webpage_url; // 页面URL
@property (nonatomic , assign) NSInteger fps; // 视频帧率
@property (nonatomic , copy) NSString * title; // 视频标题
@property (nonatomic , copy) NSArray<Formats *> * formats; // 格式数组
@property (nonatomic , copy) NSString * uploader_id; // 上传者ID
@property (nonatomic , copy) NSArray<Requested_formats *> * requested_formats; // 请求的格式数组
@property (nonatomic , copy) NSString * resolution; // 视频分辨率

@end
