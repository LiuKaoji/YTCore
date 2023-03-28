//
//  YTCoreUtility+parse.m
//  YTCore
//
//  Created by kaoji on 3/25/23.
//

#import "YTCoreUtility+parse.h"
#import "YTCoreUtility+invoke.h"
#import "YTCoreUtility+download.h"
#import "YTPanel.h"
#import "YTReachability.h"
#import "YTCoreDef.h"
#import <Python/Python.h>
#import "YTCoreDef.h"
#import "YTCoreUtility+env.h"
#import "YTFileManager.h"
#import <objc/runtime.h>
#import "NSString+Youtube.h"

@implementation YTCoreUtility (parse)
@dynamic lockParser;

- (BOOL)lockParser {
    return [objc_getAssociatedObject(self, @selector(lockParser)) boolValue];
}

- (void)setLockParser:(BOOL)lockParser {
    objc_setAssociatedObject(self, @selector(lockParser), @(lockParser), OBJC_ASSOCIATION_ASSIGN);
}

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
    
    if(self.lockParser){
        [self invokeMessage: YTParseVideoError reason: @"请勿重复提交操作!"];
        return;
    }
   
    //https://www.youtube.com/watch?v=9kBHUMSSkF8 30s Apple广告
    //https://www.youtube.com/watch?v=0QRVXnZkr1Y 几分钟演唱会歌曲
    self.lockParser = YES;
    NSString *fetchURL = url;
    dispatch_async(GLOBAL_QUEUE, ^{
        YTVideoListModel *list = [self parseVideo: fetchURL];
        dispatch_async(MAIN_QUEUE, ^{
            if(isShow && list!= nil){
                [self showPanelWithList: list];
                [self invokeMessage: YTParseVideoOk reason: @"解析成功!"];
            }else{
                [self invokeMessage: YTParseVideoError reason: @"解析失败!"];
            }
            self.lockParser = NO;
        });
    });
}

-(YTVideoListModel *)parseVideo:(NSString *)videoURL{
    
    // 标准化下载地址
    NSString *parseURL = [NSString getYouTubeVideoKeyFromURL: videoURL];
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

- (PyObject *)loadYTLibrary {
    NSString *resDir = [DOC_PATH stringByAppendingPathComponent:@"Python.framework/Resources"];
    NSString *python_path = [NSString stringWithFormat:@"PYTHONPATH=%@/Resources/lib/python3.4/site-packages/", resDir];
    NSLog(@"PYTHONPATH is: %@", python_path);
    putenv((char *)[python_path UTF8String]);
    
    NSString *scriptDir = [NSString stringWithFormat:@"正在加载脚本: %@/Resources/lib/python3.4/site-packages/ParseVideo.py", resDir];
    [self invokeMessage:YTProcess reason: scriptDir];

    PyObject *obj = PyImport_ImportModule("ParseVideo");
    BOOL isImport = (obj == NULL ? NO : YES);
    self.isPythonReady = isImport;
    if (!isImport) {
        PyErr_Print();
        [self invokeMessage:YTParseVideoError reason:@"加载脚本失败!"];
        return nil;
    } else {
        [self invokeMessage: YTProcess reason:@"脚本已加载, 开始解析视频..."];
    }
    return obj;
}

@end
