//
//  YTDownloader.m
//  YTCore
//
//  Created by kaoji on 3/22/23.
//

#import "YTDownloader.h"
#import "YTCoreDef.h"
#import "YTFileManager.h"

@implementation YTDownloader {
    NSURL *_dstURL;
    NSInteger _retryCount;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return self;
}

- (void)startDownloadWithURL:(NSURL *)srcURL toDestination: (NSURL *)dstURL {
    _retryCount = 3;//重试次数
    _dstURL = dstURL;
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL: srcURL];
    [downloadTask resume];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    [YTFileManager moveFileFrom:location.path to:_dstURL.path completion:^(BOOL success, NSError * _Nonnull error) {
        // 主线程回调错误信息
        dispatch_async(MAIN_QUEUE, ^{
            if ([self.delegate respondsToSelector:@selector(didReceiveDownloadURL:)]) {
                [self.delegate didReceiveDownloadURL:self->_dstURL];
            }
            if(self.downloadURLBlock){
                self.downloadURLBlock(self->_dstURL);
            }
            [self.session invalidateAndCancel];
        });
    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    NSString *writtenStr = FILE_SIZE_STRING(totalBytesWritten);
    NSString *totalStr = FILE_SIZE_STRING(totalBytesExpectedToWrite);
    NSString *progressString = [NSString stringWithFormat:@"%@/%@", writtenStr, totalStr];

    if (isnan(progress) || totalBytesExpectedToWrite <= 0) {
        progress = 0.0;
        progressString = [NSString stringWithFormat:@"%@/%@", writtenStr, @"未知"];
    }

    // 主线程回调进度
    dispatch_async(MAIN_QUEUE, ^{
        if ([self.delegate respondsToSelector:@selector(didReceiveDownloadSize:withProgress:)]) {
            [self.delegate didReceiveDownloadSize:progressString withProgress:progress];
        }
        if(self.downloadSizeBlock){
            self.downloadSizeBlock(progressString, progress);
        }
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    
    // 判断下载是否失败并且还有重试次数 而且http没有404 而且不是主动取消
    if (error && _retryCount > 0 && httpResponse.statusCode != 404 && error.code != NSURLErrorCancelled) {
        
        // 重新创建一个下载任务
        NSURLSessionDownloadTask *newTask = [session downloadTaskWithURL:task.currentRequest.URL];
        
        // 更新重试次数
        _retryCount--;
        
        // 重新执行下载任务
        [newTask resume];
        return;
    }

    if (error) {
        // 处理网络连接错误
        NSLog(@"下载失败：%@", error.localizedDescription);
        
        // 主线程回调错误信息
        dispatch_async(MAIN_QUEUE, ^{
            if ([self.delegate respondsToSelector:@selector(didReceiveError:)]) {
                [self.delegate didReceiveError:error];
            }
            if(self.errorBlock){
                self.errorBlock(error);
            }
        });
    }
}

@end
