//
//  YTCoreUtility+parse.m
//  YTCore
//
//  Created by kaoji on 3/25/23.
//

#import "YTCoreUtility+parse.h"
#import "YTCoreUtility+invoke.h"
#import "YTPanel.h"
#import "YTReachability.h"
#import "YTCoreDef.h"
#import <Python/Python.h>
#import "YTCoreUtility+download.h"
#import "YTCoreDef.h"
#import "YTCoreUtility+env.h"
#import "YTFileManager.h"

@implementation YTCoreUtility (parse)

-(void)showPanelWithList:(YTVideoListModel *)list {
    
    __block YTPanel *panel = [[YTPanel alloc] initWithFrame:UIScreen.mainScreen.bounds list: list];
    panel.trackCallback = ^(YTVideo * _Nonnull track){
        [self downloadSelectedVideo: track];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        [panel dismissToBottom];
#pragma clang diagnostic pop
    };
    [panel presentFromBottom];
}

-(void)parseYTWithparseYTWithUrl:(NSString *)url isShowPanel: (BOOL)isShow{
   
    //https://www.youtube.com/watch?v=9kBHUMSSkF8 30s Apple广告
    //https://www.youtube.com/watch?v=0QRVXnZkr1Y 几分钟演唱会歌曲
    NSString *fetchURL = url;
    dispatch_async(GLOBAL_QUEUE, ^{
        YTVideoListModel *list = [self parseVideo: fetchURL];
        dispatch_async(MAIN_QUEUE, ^{
            if(isShow && list!= nil){
                [self showPanelWithList: list];
            }
        });
    });
}

-(YTVideoListModel *)parseVideo:(NSString *)videoURL{
    
    // 标准化下载地址
    NSString *parseURL = [self getYouTubeVideoKeyFromURL: videoURL];
    if (parseURL == nil) {
        return nil;
    }
    
    char *cProxy = NULL;
    PyObject *parser = [self loadYTLibrary];
    if(parser == nil){
        return  nil;
    }
    PyObject *result = PyObject_CallMethod(parser, "SniffingURL","(s)", [parseURL UTF8String],cProxy);
    
    if (result == NULL) {
        free(result);
        return nil;
    }
    // 获取JSON
    char * resultCString = NULL;
    PyArg_Parse(result, "s", &resultCString);
    if (resultCString == NULL) {
        free(result);
        Py_DECREF(parser);
        return nil;
    }
    
    // 解释JSON
    NSString *parseJSONStr = [NSString stringWithUTF8String:resultCString];
    YTVideoListModel *listModel = [YTVideoListModel parseMediaWithJSONStr: parseJSONStr andSource: videoURL];
    free(result);
    
    // 自定义处理数据回调
    if(listModel != nil && listModel.title.length > 0 && listModel.duration.length > 0) {
        [self invokeParseJSON: parseJSONStr];
        [self invokeParseList: listModel];
        return listModel;
    }
    [self invokeMessage: YTParseVideoError reason: parseJSONStr];
    return nil;
}

// 拼合网址 可以避免传入列表网址 耗时过长
- (NSString *)getYouTubeURLFromVideoKey:(NSString *)videoKey {
    if (!videoKey || [videoKey isEqualToString:@""]) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", videoKey];
}

// 从YT网址中提取videoId
- (NSString *)getYouTubeVideoKeyFromURL:(NSString *)urlString {
    NSError *error = NULL;
    
    // 创建正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=watch\\?v=|/videos/|embed\\/)[^#\\&\\?]*" options:NSRegularExpressionCaseInsensitive error:&error];
    
    // 匹配视频 key
    NSTextCheckingResult *match = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
    
    // 返回视频 key
    if (match) {
        NSString *videoKey = [urlString substringWithRange:match.range];
        return [self getYouTubeURLFromVideoKey:videoKey];
    } else {
        return nil;
    }
}

- (PyObject *)loadYTLibrary {
    NSString *resDir = [DOC_PATH stringByAppendingPathComponent:@"Python.framework/Resources"];
    NSString *python_path = [NSString stringWithFormat:@"PYTHONPATH=%@/python_scripts:%@/Resources/lib/python3.4/site-packages/", resDir, resDir];
    NSLog(@"PYTHONPATH is: %@", python_path);
    putenv((char *)[python_path UTF8String]);

    PyObject *obj = PyImport_ImportModule("ParseVideo");
    BOOL isImport = (obj == NULL ? NO : YES);
    self.isPythonReady = isImport;
    if (!isImport) {
        PyErr_Print();
        [self invokeMessage:YTParseVideoError reason:@"加载脚本失败!"];
        return nil;
    } else {
        [self invokeMessage: YTOperation reason:@"脚本已加载, 开始解析视频..."];
    }
    return obj;
}

@end
