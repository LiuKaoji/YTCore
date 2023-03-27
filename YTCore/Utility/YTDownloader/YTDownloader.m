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
    [self.session invalidateAndCancel];

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

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    if (httpResponse.statusCode == 404) {
        // 处理文件不存在错误
        NSLog(@"文件不存在");
    }
}

@end
