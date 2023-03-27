//
//  MainController.m
//  Example
//
//  Created by kaoji on 3/13/23.
//

#import "MainController.h"
#import "VideoOperation.h"

@implementation MainController
static MainController *shared = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //代理
    [self setupUI];
    
    self.utility = [[YTCoreUtility alloc] init];
    self.utility.delegate = self;
    
    LOG_D(@"============温馨提示========");
    LOG_D(@"注册环境: 初始化Python环境");
    LOG_D(@"解释视频: 加载脚本解析视频");
    LOG_D(@"连通检测: 尝试访问Youtube");
    LOG_D(@"更新环境: 下载更新依赖库");
    LOG_D(@"==========================");
}

#pragma mark - 点击注册环境
- (IBAction)onClickRegistButton:(id)sender {
    LOG_D(@"正在配置环境...");
    BOOL isSelected =  _registButton.isSelected;
    isSelected ? [self.utility tearDown]:[self.utility setup];
    [self lockButtons];
}

#pragma mark - 点击更新YT库
- (IBAction)onClickUpdate:(id)sender {
    // 更新按钮点击事件
    [self.utility update];
    [self lockButtons];
}

#pragma mark - 检测youtube是否能链接
- (IBAction)checkConnection:(id)sender {
    [self.utility checkConnection];
    [self lockButtons];
}

#pragma mark - 点击解释视频
- (IBAction)onClickParseVideo:(id)sender {
    
    //https://www.youtube.com/watch?v=9kBHUMSSkF8 30s Apple广告
    //https://www.youtube.com/watch?v=0QRVXnZkr1Y 几分钟演唱会歌曲
    NSString *fetchURL = self.textField.text;
    [self.utility parseVideo: fetchURL showPanel: YES];
    [self lockButtons];
}

#pragma mark - YTCoreDelegate 环境状态代理
-(void)onMessageEvent:(YTStatusInfo *_Nonnull)info{
    
    switch (info.status) {
        case YTInitOk:
            LOG_D(info.description);
            self.registButton.selected = YES;
            break;
        case YTInitError:
            LOG_E(info.description);
            self.registButton.selected = NO;
            break;
       
        case YTDeinitOk:
            LOG_D(info.description);
            self.registButton.selected = NO;
            break;
        case YTDeinitError:
            self.registButton.selected = NO;
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
            LOG_D(info.description);
            break;
        case YTMediaMergeError:
            LOG_E(info.description);
            break;
    }
    
    switch (info.status) {
        case YTLibraryProgress:
        case YTMediaDLProgress:
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
}

//视频下载完成
-(void)didDownloadVideo:(NSURL *_Nonnull)fileURL{
    NSLog(@"视频下载完成 已存储至: %@", fileURL);
    [VideoOperation showActionSheetWithURL: fileURL inController: self];
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

//==========初始化及UI处理================
-(void)setupUI{
    // 渐变背景
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.frame;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:1.0].CGColor];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    //按钮锁定颜色
    [_registButton setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_updateButton setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_parseButton setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [_registButton setTitle:@"关闭环境" forState:UIControlStateSelected];
    [_registButton setTitle:@"注册环境" forState:UIControlStateNormal];
}


-(void)lockButtons{
    dispatch_async(MAIN_QUEUE, ^{
        self.registButton.enabled = NO;
        self.updateButton.enabled = NO;
        self.parseButton.enabled = NO;
        self.connectButton.enabled = NO;
    });
}

-(void)unlockButtons {
    dispatch_async(MAIN_QUEUE, ^{
        self.registButton.enabled = YES;
        self.updateButton.enabled = YES;
        self.parseButton.enabled = YES;
        self.connectButton.enabled = YES;
    });
}


@end

