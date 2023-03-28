//
//  YTProtocolV2.h
//  YTCore
//
//  Created by kaoji on 3/24/23.
//

#import <Foundation/Foundation.h>

/// YTCore 运行状态
typedef NS_ENUM(NSInteger, YTStatus) {
    
    // 环境 (加载脚本)
    YTInitOk = 1101,      // 启动成功
    YTInitError,          // 启动失败
    YTDeinitOk,           // 关闭成功
    YTDeinitError,        // 关闭失败
    
    // 网络
    YTConnectionError,    // 无法访问Youtube
    YTConnectionOK,       // 成功访问Youtube

    // 脚本(更新脚本)
    YTLibraryLatest,      // 更新成功
    YTLibraryError,       // 更新失败
    YTLibraryProgress,    // 更新进度

    // 解析(使用脚本解析)
    YTParseVideoOk,       // 解析成功
    YTParseVideoError,    // 解析失败

    // 下载(下载指定分辨率视频)
    YTMediaDLOk,          // 下载完成
    YTMediaDLError,       // 下载失败
    YTMediaDLProgress,    // 下载进度
    YTMediaMergeError,    // 合并失败
    
    YTOperation,           // 操作提示
    YTProcess,       // 处理过程
};
