//
//  YTParseModel.h
//  YTCore
//
//  Created by kaoji on 3/13/23.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface Thumbnails :NSObject
@property (nonatomic , assign) NSInteger              height;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * resolution;
@property (nonatomic , assign) NSInteger              width;

@end


@interface Formats :NSObject
@property (nonatomic , copy) NSString              * acodec;
@property (nonatomic , assign) NSInteger              asr;
@property (nonatomic , assign) NSInteger              quality;
@property (nonatomic , copy) NSString              * vcodec;
@property (nonatomic , copy) NSString              * protocol;
@property (nonatomic , copy) NSString              * fps;
@property (nonatomic , assign) NSInteger              filesize;
@property (nonatomic , copy) NSString              * width;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , assign) CGFloat              tbr;
@property (nonatomic , assign) CGFloat              abr;
@property (nonatomic , copy) NSString              * format_note;
@property (nonatomic , copy) NSString              * format;
@property (nonatomic , copy) NSString              * ext;
@property (nonatomic , copy) NSString              * container;
@property (nonatomic , copy) NSString              * height;
@property (nonatomic , copy) NSString              * format_id;

@end


@interface Requested_formats :NSObject
@property (nonatomic , copy) NSString              * acodec;
@property (nonatomic , copy) NSString              * asr;
@property (nonatomic , assign) NSInteger              quality;
@property (nonatomic , copy) NSString              * vcodec;
@property (nonatomic , copy) NSString              * protocol;
@property (nonatomic , assign) NSInteger              fps;
@property (nonatomic , assign) NSInteger              filesize;
@property (nonatomic , assign) NSInteger              width;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , assign) CGFloat              tbr;
@property (nonatomic , copy) NSString              * format_note;
@property (nonatomic , copy) NSString              * format;
@property (nonatomic , copy) NSString              * ext;
@property (nonatomic , assign) NSInteger              height;
@property (nonatomic , copy) NSString              * container;
@property (nonatomic , assign) CGFloat              vbr;
@property (nonatomic , copy) NSString              * format_id;

@end

@interface YTParseModel :NSObject
@property (nonatomic , assign) NSInteger              width;
@property (nonatomic , copy) NSString              * playlist_index;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , assign) CGFloat              vbr;
@property (nonatomic , copy) NSString              * ext;
@property (nonatomic , copy) NSString              * channel_url;
@property (nonatomic , copy) NSArray<Thumbnails *>              * thumbnails;
@property (nonatomic , copy) NSString              * stretched_ratio;
@property (nonatomic , assign) NSInteger              duration;
@property (nonatomic , copy) NSString              * acodec;
@property (nonatomic , copy) NSString              * playlist;
@property (nonatomic , copy) NSString              * extractor;
@property (nonatomic , copy) NSString              * format_id;
@property (nonatomic , copy) NSString              * channel;
@property (nonatomic , assign) NSInteger              age_limit;
@property (nonatomic , copy) NSString              * webpage_url_basename;
@property (nonatomic , copy) NSString              * thumbnail;
@property (nonatomic , assign) NSInteger              height;
@property (nonatomic , copy) NSString              * uploader_url;
@property (nonatomic , assign) CGFloat              abr;
@property (nonatomic , copy) NSString              * channel_id;
@property (nonatomic , copy) NSString              * extractor_key;
@property (nonatomic , copy) NSString              * uploader;
@property (nonatomic , copy) NSString              * format;
@property (nonatomic , copy) NSString              * requested_subtitles;
@property (nonatomic , assign) NSInteger              view_count;
@property (nonatomic , copy) NSString              * vcodec;
@property (nonatomic , copy) NSString              * display_id;
@property (nonatomic , copy) NSArray<NSString *>              * categories;
@property (nonatomic , copy) NSString              * upload_date;
@property (nonatomic , copy) NSString              * webpage_url;
@property (nonatomic , assign) NSInteger              fps;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSArray<Formats *>              * formats;
@property (nonatomic , copy) NSString              * uploader_id;
@property (nonatomic , copy) NSArray<Requested_formats *>              * requested_formats;
@property (nonatomic , copy) NSString              * resolution;

@end
