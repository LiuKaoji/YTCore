//
//  YTCoreUtility+update.h
//  YTCore
//
//  Created by kaoji on 3/25/23.
//

#import "YTCoreUtility.h"
#import "YTDownloader.h"

NS_ASSUME_NONNULL_BEGIN

// 这个类别扩展了YTCoreUtility类，用于更新YouTube库。
@interface YTCoreUtility (update)

// 这个属性是YTDownloader类的实例，用于更新YouTube库。
@property (nonatomic, strong) YTDownloader *updater;

// 这个方法用于更新YouTube库。
-(void)updateYTLibrary;

@end


NS_ASSUME_NONNULL_END
