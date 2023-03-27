//
//  YTVideo.h
//  YDL
//
//  Created by ceonfai on 2019/1/19.
//  Copyright © 2019 Ceonfai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTVideo;
typedef void (^MediaClickBlock)(YTVideo * _Nonnull track);

// 这个类定义了YTVideo对象和YTVideoListModel对象，用于存储视频信息。
@class YTVideo;

// 这个typedef定义了一个块，用于响应媒体点击事件。
typedef void (^MediaClickBlock)(YTVideo * _Nonnull track);

NS_ASSUME_NONNULL_BEGIN

// YTVideo对象用于存储单个视频的信息。
@interface YTVideo : NSObject

// 这些属性用于存储视频的各种信息，如标题、时长、分辨率、文件大小、下载链接等等。
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * duration;
@property (nonatomic,copy)NSString * resolution;
@property (nonatomic,copy)NSString * size;
@property (nonatomic,copy)NSString * audioLink;
@property (nonatomic,copy)NSString * videoLink;
@property (nonatomic,copy)NSString * vcodec;
@property (nonatomic,copy)NSString * acodec;
@property (nonatomic,copy)NSString * ext;
@property (nonatomic,assign)BOOL pureVideo;

@end

// YTVideoListModel对象用于存储解析过滤后的视频列表。
@interface YTVideoListModel : NSObject

// 这些属性用于存储视频列表的各种信息，如标题、时长、缩略图、源链接、音视频轨道等等。
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * duration;
@property (nonatomic,copy)NSString * thumbnail;
@property (nonatomic,copy)NSString * sourceLink;
@property (nonatomic,copy)NSArray <YTVideo *> * tracks;

// 这个方法用于解析JSON字符串并返回YTVideoListModel对象。
+(YTVideoListModel *)parseMediaWithJSONStr:(NSString *)jsonStr andSource:(NSString *)source;

// 这个方法用于解析视频列表的描述信息。
-(NSString *)parseDescription;

@end

NS_ASSUME_NONNULL_END

