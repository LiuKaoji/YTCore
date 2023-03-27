/*
* Module:   YTStatusInfo @ YTCore
*
* Function: YTCore 内部接口状态回调数据结构
*
* Version: 1.0.0
*/

#import <Foundation/Foundation.h>
#import "YTStatus.h"

NS_ASSUME_NONNULL_BEGIN

// YTCore状态数据模型
@interface YTStatusInfo : NSObject

// YTStatus枚举表示状态
@property (nonatomic, assign) YTStatus status;

// 包含附加信息的可选数据字典
@property (nonatomic, strong, nullable) NSMutableDictionary *userInfo;

// YTStatus枚举的可选中文解释
@property (nonatomic, strong, nullable) NSString *statusDescription;

// 不可用的默认初始化方法
-(instancetype)init NS_UNAVAILABLE;

// 使用给定的YTStatus枚举值初始化状态信息实例的指定初始化方法
-(instancetype)initWithState:(YTStatus)status NS_DESIGNATED_INITIALIZER;

// 设置状态描述
- (void)setDescription:(NSString *_Nullable)description;

// 获取状态描述
- (nullable NSString *)description;

// 设置状态进度
- (void)setProgress:(CGFloat)progress;

// 获取状态进度
- (CGFloat)progress;

@end



NS_ASSUME_NONNULL_END
