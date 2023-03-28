//
//  MainViewModel.h
//  Example
//
//  Created by kaoji on 3/28/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YTCore/YTCore.h>
#import "MP4FileController.h"
#import "WkWebBrowser.h"
#import "UIViewController+Alert.h"
#import "MainViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OperationCallback)(NSString *operation);
typedef void (^MessageCallback)(NSString *message, BOOL isError);
typedef void (^ParseJSONCallback)(NSString *jsonString);
typedef void (^ParseVideoCallback)(YTVideoListModel *parseList);
typedef void (^DownloadVideoCallback)(NSURL *fileURL);

@interface MainViewModel : NSObject <YTCoreDelegate>

@property (nonatomic, strong) YTCoreUtility *utility; ///< YTCoreUtility实例
@property (nonatomic, copy) OperationCallback operationCallback; ///< 操作回调
@property (nonatomic, copy) MessageCallback messageCallback; ///< 消息回调
@property (nonatomic, copy) ParseJSONCallback parseJSONCallback; /// 解析JSON回调
@property (nonatomic, copy) ParseVideoCallback parseVideoCallback; ///< 解析模型列表回调
@property (nonatomic, copy) DownloadVideoCallback downloadVideoCallback; ///< 下载回调

/**
 * 启动服务
 */
- (void)startService;

/**
 * 检查连接
 */
- (void)checkConnection;

/**
 * 更新YT库
 */
- (void)updateLibrary;

/**
 * 解析视频
 * @param urlString 视频地址
 * @param showPanel 是否显示进度面板
 */
- (void)parseVideoWithURLString:(NSString *)urlString shouldShowPanel:(BOOL)showPanel;

/**
 * 打开Mp4文件控制器
 * @param parentController 父控制器
 */
- (void)openMp4FileController:(UIViewController *)parentController;

/**
 * 打开浏览器
 * @param parentController 父控制器
 * @param urlHandle URL回调
 */
- (void)openBrowser:(UIViewController *)parentController onURLChange:(URLBlock)urlHandle;

@end


NS_ASSUME_NONNULL_END
