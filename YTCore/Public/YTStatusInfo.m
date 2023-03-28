//
//  YTStatusInfo.m
//  YTCore
//
//  Created by kaoji on 3/24/23.
//

#import "YTStatusInfo.h"

@implementation YTStatusInfo

- (instancetype)initWithState:(YTStatus)status {
    self = [super init];
    if (self) {
        _status = status;
        _userInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setDescription:(NSString *_Nullable)description {
    [self.userInfo setObject:description forKey:@"description"];
}

- (nullable NSString *)description {
    return [self.userInfo objectForKey:@"description"];
}

- (void)setError:(NSError *_Nullable)error {
    [self.userInfo setObject:error forKey:@"error"];
}

- (nullable NSError *)error {
    return [self.userInfo objectForKey:@"error"];
}

- (void)setProgress:(CGFloat)progress {
    [self.userInfo setObject:@(progress) forKey:@"progress"];
}

- (CGFloat)progress {
    return [[self.userInfo objectForKey:@"progress"] floatValue];
}

-(NSString *)statusDescription:(YTStatus)status{
    NSString *desc;
    switch (status) {
        case YTInitOk:
            desc = @"YTCore初始化成功";
            break;
        case YTInitError:
            desc = @"YTCore初始化失败";
            break;
        case YTDeinitOk:
            desc = @"YTCore关闭成功";
            break;
        case YTDeinitError:
            desc = @"YTCore关闭失败";
            break;
        case YTConnectionError:
            desc = @"无法访问youtueb网站";
            break;
        case YTConnectionOK:
            desc = @"可访问youtube网站";
            break;
        case YTLibraryLatest:
            desc = @"依赖库已更新";
            break;
        case YTLibraryError:
            desc = @"依赖库更新失败";
            break;
        case YTLibraryProgress:
            desc = @"依赖库更新进度";
            break;
        case YTParseVideoOk:
            desc = @"解析视频成功";
            break;
        case YTParseVideoError:
            desc = @"解析视频失败";
            break;
        case YTOperation:
            desc = @"操作提示";
            break;
        case YTMediaDLOk:
            desc = @"下载媒体成功";
            break;
        case YTMediaDLError:
            desc = @"下载媒体失败";
            break;
        case YTMediaDLProgress:
            desc = @"下载媒体进度";
            break;
        case YTMediaMergeError:
            desc = @"合并媒体轨道失败";
            break;
        case YTProcess:
            desc = @"正在处理";
            break;
    }
    return desc;
}

-(NSString *)statusDescription{
    return [self statusDescription: self.status];
}

@end

