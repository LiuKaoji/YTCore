//
//  MainController.m
//  Example
//
//  Created by kaoji on 3/13/23.
//

#import "MainController.h"
#import "MP4FileController.h"
#import "WkWebBrowser.h"
#import "UIViewController+Alert.h"

@implementation MainController
static MainController *shared = nil;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.utility = [[YTCoreUtility alloc] init];
    self.utility.delegate = self;

    [self startService];
    [self onClickConnection: nil];
}

//#pragma mark - 点击注册环境
- (void)startService {
    BOOL isPythonReady =  self.utility.isPythonReady;
    isPythonReady ? [self.utility tearDown]:[self.utility setup];
    [self lockButtons];
}

#pragma mark - 点击更新YT库
- (IBAction)onClickUpdate:(id)sender {
    // 更新按钮点击事件
    [self showAlertWithConfirmation:@"更新解析库" message:@"当你确认网络正常,无法解析视频时,请尝试获取最新版本解析库" confirmationHandler:^{
        [self.utility update];
        [self lockButtons];
    }];
}

#pragma mark - 检测youtube是否能链接
- (IBAction)onClickConnection:(id)sender {

    // 更新按钮点击事件
    [self showAlertWithConfirmation:@"检查网络" message:@"尝试访问youtube网站, 以确认当前网络环境是否适合本工具" confirmationHandler:^{
        [self.utility checkConnection];
        [self lockButtons];
    }];
}


#pragma mark - 点击解释视频
- (IBAction)onClickParseVideo:(id)sender {
    
    //https://www.youtube.com/watch?v=9kBHUMSSkF8 30s Apple广告
    //https://www.youtube.com/watch?v=0QRVXnZkr1Y 几分钟演唱会歌曲
    NSString *fetchURL = self.textField.text;
    [self.utility parseVideoWithURLString:fetchURL showPanel:YES];
    [self lockButtons];
}

#pragma mark - YTCoreDelegate 环境状态代理
-(void)onMessageEvent:(YTStatusInfo *_Nonnull)info{
    
    switch (info.status) {
        case YTInitOk:
            LOG_D(info.description);
            break;
        case YTInitError:
            LOG_E(info.description);
            break;
       
        case YTDeinitOk:
            LOG_D(info.description);
            break;
        case YTDeinitError:
            LOG_E(info.description);
            break;
        case YTConnectionError:
            LOG_E(info.description);
            break;
        case YTConnectionOK:
            LOG_D(info.description);
            break;
        case YTLibraryLatest:
            LOG_D(info.description);
            break;
        case YTLibraryError:
            LOG_D(info.description);
            break;
        case YTLibraryProgress:
            LOG_D(info.description);
            break;
        case YTParseVideoOk:
            LOG_D(info.description);
            break;
        case YTParseVideoError:
            LOG_E(info.description);
            break;
        case YTOperation:
            LOG_D(info.description);
            break;
        case YTMediaDLOk:
            LOG_D(info.description);
            break;
        case YTMediaDLError:
            LOG_E(info.description);
            break;
        case YTMediaDLProgress:
            //LOG_D(info.description);
            break;
        case YTMediaMergeError:
            LOG_E(info.description);
            break;
    }
    
    switch (info.status) {
        case YTLibraryProgress:
        case YTMediaDLProgress:
        case YTOperation:
            break;
        default:
            [self unlockButtons];
    }
}

//脚本返回的JSON字符串
-(void)didParseJSON:(NSString *_Nonnull)jsonStr{
    NSURL *tempJSON = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"parse.json"]];
    [[jsonStr dataUsingEncoding: NSUTF8StringEncoding] writeToURL:tempJSON atomically:true];
}

//经过解析过滤的模型
-(void)didParseList:(YTVideoListModel *_Nonnull)list{
    NSLog(@"视频解析完成 共有%zd个分辨率提供下载", list.tracks.count);
    [self unlockButtons];
}

//视频下载完成
-(void)didDownloadVideo:(NSURL *_Nonnull)fileURL{
    NSLog(@"视频下载完成 已存储至: %@", fileURL);
    [self openMp4FileController];
}

#pragma mark - 用于简写LOG打印
+(MainController *)shared {
    return shared;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    @synchronized(shared) {
        if (shared == nil) {
            shared = [super initWithCoder:aDecoder];
        }
    }
    self = shared;
    return self;
}

-(void)lockButtons{
    dispatch_async(MAIN_QUEUE, ^{
        self.updateButton.enabled = NO;
        self.parseButton.enabled = NO;
        self.connectButton.enabled = NO;
        self.folderButton.enabled = NO;
        self.browserButton.enabled = NO;
    });
}

-(void)unlockButtons {
    dispatch_async(MAIN_QUEUE, ^{
        self.updateButton.enabled = YES;
        self.parseButton.enabled = YES;
        self.connectButton.enabled = YES;
        self.folderButton.enabled = YES;
        self.browserButton.enabled = YES;
    });
}

- (IBAction)onClickFolder:(id)sender {
    [self openMp4FileController];
}

- (IBAction)onClickBrowser:(id)sender {
    [self openBrowser];
}


-(void)openMp4FileController{
    NSError *error = nil;
    NSURL *docDirURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&error];
    if (!error) {
        MP4FileController *fileController = [[MP4FileController alloc] initWithDirectoryURL: docDirURL];
        [self.navigationController pushViewController:fileController animated:YES];
    }
}

-(void)openBrowser{
    NSURL *ytURL = [NSURL URLWithString: @"https://m.youtube.com"];
    WkWebBrowser *browser = [[WkWebBrowser alloc] initWithURL: ytURL];
    browser.urlHandle = ^ (NSURL *webURL){
        self.textField.text = webURL.absoluteString;
        [self onClickParseVideo: nil];
    };
    [self.navigationController pushViewController: browser animated:YES];
}

@end

