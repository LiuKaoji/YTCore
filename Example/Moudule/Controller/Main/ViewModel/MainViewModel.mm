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

- (void)updateLibrary {
    [self.utility update];
}

- (void)parseVideoWithURLString:(NSString *)urlString shouldShowPanel:(BOOL)showPanel{
    [self.utility parseVideoWithURLString:urlString showPanel: showPanel];
}

#pragma mark - YTCoreDelegate

- (void)onMessageEvent:(YTStatusInfo *_Nonnull)info {
    switch (info.status) {
        case YTInitOk:
        case YTDeinitOk:
        case YTConnectionOK:
        case YTLibraryLatest:
        case YTParseVideoOk:
        case YTProcess:
        case YTMediaDLOk:
            if (self.messageCallback) {
                self.messageCallback(info.description, NO);
            }
            break;
            
        case YTInitError:
        case YTDeinitError:
        case YTConnectionError:
        case YTLibraryError:
        case YTParseVideoError:
        case YTMediaDLError:
        case YTMediaMergeError:
            if (self.messageCallback) {
                self.messageCallback(info.description, YES);
            }
            break;
            
        case YTLibraryProgress:
        case YTMediaDLProgress:
            if (self.messageCallback) {
                self.messageCallback(info.description, NO);
            }
            break;
            
        case YTOperation:
            if (self.operationCallback) {
                self.operationCallback(info.description);
            }
            break;
    }
}

- (void)didParseList:(YTVideoListModel *)list {
    if (self.parseVideoCallback) {
        self.parseVideoCallback(list);
    }
}

-(void)didParseJSON:(NSString *_Nonnull)jsonStr{
    if (self.parseJSONCallback) {
        self.parseJSONCallback(jsonStr);
    }
}

- (void)didDownloadVideo:(NSURL *)fileURL {
    if (self.downloadVideoCallback) {
        self.downloadVideoCallback(fileURL);
    }
}

- (void)openMp4FileController:(UIViewController *)parentController{
    NSError *error = nil;
    NSURL *docDirURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&error];
    if (!error) {
        MP4FileController *fileController = [[MP4FileController alloc] initWithDirectoryURL: docDirURL];
        [parentController.navigationController pushViewController:fileController animated:YES];
    }
}

- (void)openBrowser:(UIViewController *)parentController onURLChange:(URLBlock)urlHandle{
    NSURL *ytURL = [NSURL URLWithString: @"https://m.youtube.com"];
    WkWebBrowser *browser = [[WkWebBrowser alloc] initWithURL: ytURL];
    browser.urlHandle = urlHandle;
//    ^ (NSURL *webURL){
//        self.textField.text = webURL.absoluteString;
//        [self onClickParseVideo: nil];
//    };
    [parentController.navigationController pushViewController: browser animated:YES];
}

@end
