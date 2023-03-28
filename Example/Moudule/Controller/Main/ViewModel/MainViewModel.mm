//
//  MainViewModel.m
//  Example
//
//  Created by kaoji on 3/28/23.
//

#import "MainViewModel.h"


@implementation MainViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _utility = [[YTCoreUtility alloc] init];
        _utility.delegate = self;
    }
    return self;
}

- (void)startService {
    BOOL isPythonReady = self.utility.isPythonReady;
    isPythonReady ? [self.utility tearDown] : [self.utility setup];
}

- (void)checkConnection {
    [self.utility checkConnection];
}

- (void)update {
    [self.utility update];
}

- (void)parseVideoWithURLString:(NSString *)urlString {
    [self.utility parseVideoWithURLString:urlString showPanel:YES];
}

#pragma mark - YTCoreDelegate

- (void)onMessageEvent:(YTStatusInfo *_Nonnull)info {
    switch (info.status) {
        case YTInitOk:
        case YTDeinitOk:
        case YTConnectionOK:
        case YTLibraryLatest:
        case YTParseVideoOk:
        case YTMediaDLOk:
            if (self.onMessageEvent) {
                self.onMessageEvent(info.description);
            }
            break;
            
        case YTInitError:
        case YTDeinitError:
        case YTConnectionError:
        case YTLibraryError:
        case YTParseVideoError:
        case YTMediaDLError:
        case YTMediaMergeError:
            if (self.onMessageEvent) {
                self.onMessageEvent(info.description);
            }
            break;
            
        case YTLibraryProgress:
        case YTMediaDLProgress:
        case YTOperation:
            break;
    }
}

- (void)didParseList:(YTVideoListModel *)list {
    if (self.onParseVideo) {
        self.onParseVideo(list);
    }
}

- (void)didDownloadVideo:(NSURL *)fileURL {
    if (self.onDownloadVideo) {
        self.onDownloadVideo(fileURL);
    }
}

@end
