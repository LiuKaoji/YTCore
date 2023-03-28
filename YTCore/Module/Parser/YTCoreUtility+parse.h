//
//  YTCoreUtility+parse.h
//  YTCore
//
//  Created by kaoji on 3/25/23.
//

#import "YTCoreUtility.h"

NS_ASSUME_NONNULL_BEGIN

// 这个类别扩展了YTCoreUtility类，用于解析YouTube网页。
@interface YTCoreUtility (parse)

@property (nonatomic, assign) BOOL lockParser;//不允许同时提交两个操作

// 这个方法用于解析YouTube网页，传递视频的URL和一个布尔值，指示是否显示面板。
-(void)parseYTWithparseYTWithUrl:(NSString *)url isShowPanel: (BOOL)isShow;

@end


NS_ASSUME_NONNULL_END
