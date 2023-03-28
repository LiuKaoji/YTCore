//
//  YTCoreUtility.m
//  YTCore
//
//  Created by kaoji on 3/24/23.
//

#import "YTCoreUtility.h"
#import "YTCoreUtility+env.h"
#import "YTCoreUtility+update.h"
#import "YTCoreUtility+parse.h"
#import "YTCoreUtility+invoke.h"
#import "YTReachability.h"

@implementation YTCoreUtility

/// 初始化资源
- (void)setup {
    [self invokeMessage:YTOperation reason: @"启动环境.."];
    [self prepare];
}

/// 释放资源
- (void)tearDown {
    [self invokeMessage:YTOperation reason: @"关闭环境.."];
    _isPythonReady = NO;
    [self destroy];
}

/// 更新依赖库
- (void)update {
    if (!self.isPythonReady) {
        [self invokeMessage:YTLibraryError reason:@"请先启动环境!"];
        return;
    }
    [self invokeMessage:YTOperation reason: @"更新youtube_dl.."];
    [self updateYTLibrary];
}

/// 解析视频
- (void)parseVideoWithURLString:(NSString *)urlString showPanel:(BOOL)isShow {
    if (!self.isPythonReady) {
        [self invokeMessage:YTParseVideoError reason:@"请先注册环境!"];
        return;
    }
    [self invokeMessage:YTOperation reason: @"正在解析视频.."];
    [self parseYTWithparseYTWithUrl:urlString isShowPanel:isShow];
}

/// 尝试与youtube建立连接
- (void)checkConnection {
  
    [self invokeMessage:YTOperation reason: @"访问youtube.."];
    [[YTReachability shared] checkWithURLString:@"https://www.youtube.com" completion:^(BOOL reachable, NSInteger code) {
        YTStatus status = reachable ? YTConnectionOK : YTConnectionError;
        NSString *reachableText = reachable ? @"连接成功" : @"连接失败";
        [self invokeMessage:status reason:[NSString stringWithFormat:@"%@ 状态码: %ld", reachableText, (long)code]];
    }];
}

@end
