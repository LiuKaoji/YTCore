//
//  YTCoreUtility+invoke.m
//  YTCore
//
//  Created by kaoji on 3/24/23.
//

#import "YTCoreUtility+invoke.h"
#import "YTCoreDef.h"
#import "YTStatusInfo.h"

@implementation YTCoreUtility (invoke)
-(void)invokeMessage:(YTStatus)status reason:(NSString *)reason,...{
    dispatch_async(MAIN_QUEUE, ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onMessageEvent:)]){
            YTStatusInfo *info = [[YTStatusInfo alloc] initWithState:status];
            [info setDescription: reason];
            [self.delegate onMessageEvent: info];
        }
    });
}

// 自定义处理
-(void)invokeParseJSON:(NSString *)jsonString{
    dispatch_async(MAIN_QUEUE, ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didParseJSON:)]){
            [self.delegate didParseJSON: jsonString];
        }
    });
}

-(void)invokeParseList:(YTVideoListModel *)list{
    dispatch_async(MAIN_QUEUE, ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didParseList:)]){
            [self.delegate didParseList: list];
        }
    });
}

-(void)invokeDownloadedVideo:(NSURL *)url{
    dispatch_async(MAIN_QUEUE, ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDownloadVideo:)]){
            [self.delegate didDownloadVideo: url];
        }
    });
}

@end
