//
//  YTCoreUtility+update.m
//  YTCore
//
//  Created by kaoji on 3/25/23.
//

#import "YTCoreUtility+update.h"
#import "YTCoreUtility+invoke.h"
#import "YTCoreDef.h"
#import "YTFileManager.h"
#import <objc/runtime.h>
#import <ZipArchive/ZipArchive.h>

@implementation YTCoreUtility (update)
@dynamic updater;

- (void)setUpdater:(YTDownloader *)updater {
    objc_setAssociatedObject(self, @selector(updater), updater, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject *)updater {
    return objc_getAssociatedObject(self, @selector(updater));
}

-(void)updateYTLibrary{
    NSURL *srcURL = [NSURL URLWithString: @"https://codeload.github.com/rg3/youtube-dl/zip/master"];
    NSURL *dstURL = [NSURL fileURLWithPath: [TEMP_PATH stringByAppendingPathComponent:@"youtube-dl-master.zip"]];
    
    self.updater = [[YTDownloader alloc] init];
    [self.updater startDownloadWithURL:srcURL toDestination:dstURL];
    
    __weak typeof(self) weakSelf = self;
    self.updater.downloadURLBlock = ^(NSURL * _Nonnull downloadURL){
        [weakSelf replaceMoudule: downloadURL.path];
    };
    
    self.updater.errorBlock = ^(NSError * _Nonnull error){
        [weakSelf invokeMessage:YTLibraryError reason: error.localizedDescription];
    };
    
    self.updater.downloadSizeBlock = ^(NSString * _Nonnull size, CGFloat progress){
        [weakSelf invokeMessage:YTLibraryProgress reason:size];
    };
}

-(void)replaceMoudule:(NSString * _Nonnull)filePath{
    
    BOOL isSuccess = [SSZipArchive unzipFileAtPath:filePath toDestination: TEMP_PATH];
    
    //解压文件出错
    if(!isSuccess){
        [self invokeMessage:YTLibraryError reason:@"解压新库失败"];
        return;
    }
    
    //获得新版与旧版路径
    NSString *relative =  @"/Python.framework/Resources/lib/python3.4/site-packages/youtube_dl";
    NSString *sitePath = [DOC_PATH stringByAppendingString: relative];
    NSString *lastVersionPath = [[filePath stringByDeletingPathExtension] stringByAppendingPathComponent:@"youtube_dl"];
    
    //先尝试移除 以免拷贝出错
    [YTFileManager deleteDirectoryAtPath: sitePath];
    
    NSError *copyError = nil;
    //替换新旧版本
    [[NSFileManager defaultManager] copyItemAtPath:lastVersionPath toPath:sitePath error:&copyError];
    
    //删除下载缓存zip与解压文件夹
    [YTFileManager deleteFileAtPath: filePath];
    [YTFileManager deleteDirectoryAtPath: lastVersionPath];
    [YTFileManager deleteDirectoryAtPath: [filePath stringByDeletingPathExtension]];
    
    if(!copyError){
        [self invokeMessage:YTLibraryLatest reason:@"替换库成功"];
    }else{
        [self invokeMessage:YTLibraryError reason:@"替换库失败"];
    }
}

@end
