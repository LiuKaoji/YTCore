//
//  YTCoreDef.h
//  YTCore
//
//  Created by kaoji on 3/12/20.
//


#pragma mark - Dispatch Queues

// 全局并发队列
#define GLOBAL_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
// 主队列
#define MAIN_QUEUE dispatch_get_main_queue()

#pragma mark - Helper Functions

// 秒数转时间戳字符串
#define SecondsToTimeString(seconds) (seconds >= 3600 ? [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)(seconds/3600), (long)(seconds/60)%60, (long)seconds%60] : [NSString stringWithFormat:@"%02ld:%02ld", (long)(seconds/60)%60, (long)seconds%60])

// 文件大小转字符串
#define FILE_SIZE_STRING(size) ({ \
    NSArray *units = @[@"B", @"KB", @"MB", @"GB"]; \
    NSInteger index = 0; \
    double fileSize = (double)size; \
    while (fileSize > 1024 && index < units.count - 1) { \
        fileSize /= 1024.0; \
        index++; \
    } \
    [NSString stringWithFormat:@"%.2f%@", fileSize, units[index]]; \
})

#pragma mark - Bundle Image Helper

// 从bundle中读取图片
#define YTCoreImageBundle(name) \
[UIImage imageNamed:name inBundle:[NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"YTCore" withExtension:@"bundle"]] compatibleWithTraitCollection:nil]

#pragma mark - UIWindow Helper

// 查找全局显示的window
#define FIND_KEY_WINDOW ({ \
    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow; \
    if (!keyWindow) { \
        if (@available(iOS 13.0, *)) { \
            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) { \
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) { \
                    UIWindowScene *windowScene = (UIWindowScene *)scene; \
                    keyWindow = windowScene.windows.firstObject; \
                    break; \
                } \
            } \
        } \
    } \
    keyWindow; \
})
