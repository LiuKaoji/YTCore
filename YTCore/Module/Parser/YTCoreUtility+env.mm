//
//  YTCoreUtility+env.m
//  YTCore
//
//  Created by kaoji on 3/24/23.
//

#import "YTCoreUtility+env.h"
#import "YTCoreDef.h"
#import "YTStatusInfo.h"
#import "YTFileManager.h"
#import <Python/Python.h>
#import "YTCoreUtility+invoke.h"
#import <objc/runtime.h>
#import <ZipArchive/ZipArchive.h>


@implementation YTCoreUtility (env)

- (void)prepare {
    // 防止重复调用初始化
    if (self.isPythonReady) {
        return;
    }
    [self invokeMessage:YTOperation reason:@"正在启动服务..."];
    // 解压环境库
    dispatch_async(GLOBAL_QUEUE, ^{
        if ([self setupEnvironment]) {
            [self configurePython];
        }
    });
}

- (BOOL)setupEnvironment {
    NSString *envPath = [YTFileManager getYTCoreBundleFile:@"env.zip"];
    NSString *exactPath = [DOC_PATH stringByAppendingPathComponent:@"Python.framework"];


    BOOL libExist = [YTFileManager fileExistsAtPath:exactPath];
    BOOL isExact = (libExist) ? YES : ([SSZipArchive unzipFileAtPath:envPath toDestination:DOC_PATH]);

    if (!(isExact || libExist)) {
        [self invokeMessage:YTInitError reason:@"环境文件操作异常!"];
        return NO;
    }
    return YES;
}

- (void)configurePython {
    NSString *exactPath = [DOC_PATH stringByAppendingPathComponent:@"Python.framework"];
    NSString *resDir = [exactPath stringByAppendingPathComponent:@"Resources"];
    NSString *cacheDir = [exactPath stringByAppendingPathComponent:@".cache"];
    [YTFileManager createDirectoryAtPath: cacheDir];

    wchar_t *pythonHome = _Py_char2wchar([resDir UTF8String], NULL);
    Py_SetPythonHome(pythonHome);
    Py_Initialize();
    PyEval_InitThreads();

    if (!Py_IsInitialized()) {
        [self invokeMessage:YTInitError reason:@"Python初始化失败!"];
        return;
    }
    
    // 设置禁止生成.pyc文件
    putenv("PYTHONDONTWRITEBYTECODE=1");
    
    // 设置缓存目录
    const char *cache_directory = [cacheDir UTF8String];
    
    PyObject *sys = PyImport_ImportModule("sys");
    PyObject *cachePath = PyUnicode_FromString(cache_directory);
    PyObject_SetAttrString(sys, "pycache_prefix", cachePath);
    
    Py_DECREF(cachePath);
    Py_DECREF(sys);
    
    NSLog(@"PYTHON HOME: %@", resDir);
    self.isPythonReady = YES;
    
    [self invokeMessage:YTInitOk reason:@"服务已启动!"];
}

-(void)destroy{
    _PyEval_FiniThreads();
    Py_Finalize();
    [self invokeMessage: YTDeinitOk reason: @"已关闭服务"];
}

@end
