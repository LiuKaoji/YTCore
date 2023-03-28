//
//  MainController.m
//  Example
//
//  Created by kaoji on 3/13/23.
//

#import "MainController.h"
#import "MainViewModel.h"

#define SHOULD_SHOW_PANEL YES//是否显示下载弹窗面板

@interface MainController ()
@property (nonatomic, strong) MainViewModel *viewModel;
@end

@implementation MainController
static MainController *shared = nil;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
}

-(void)bindViewModel{
    self.viewModel = [[MainViewModel alloc] init];
    [self.viewModel startService];
    [self.viewModel checkConnection];
    
    // retain cycle
    __weak typeof(self) weakSelf = self;
    
    // 当前正在进行什么操作
    self.viewModel.operationCallback = ^(NSString * _Nonnull operation){
        LOG_D(operation);
        weakSelf.operationLabel.text = operation;
    };
    
    // 输出到控制台显示
    self.viewModel.messageCallback = ^(NSString * _Nonnull message, BOOL isError){
        isError ?LOG_E(message):LOG_D(message);
    };
    
    // 自定义解析处理原始数据[JSON]
    self.viewModel.parseJSONCallback = ^(NSString * _Nonnull jsonString){
        NSURL *tempJSON = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"parse.json"]];
        [[jsonString dataUsingEncoding: NSUTF8StringEncoding] writeToURL:tempJSON atomically:true];
    };
    
    // 自定义下载视频
    self.viewModel.parseVideoCallback = ^(YTVideoListModel * _Nonnull parseList){
        // ...
        
    };
    
    // 下载完成打开文件列表
    self.viewModel.downloadVideoCallback = ^(NSURL * _Nonnull fileURL){
        [weakSelf.viewModel openMp4FileController: weakSelf];
    };
    
    // 其他
    self.urlTextField.validateBlock = ^void(BOOL isValid) {
        weakSelf.parseButton.enabled = isValid;
    };
}

#pragma mark - UI点击事件
// 更新依赖库
- (IBAction)onClickUpdate:(id)sender {
    // 更新按钮点击事件
    [self showAlertWithConfirmation:@"更新解析库" message:@"当你确认网络正常,无法解析视频时,请尝试获取最新版本解析库" confirmationHandler:^{
        [self.viewModel updateLibrary];
    }];
}

// 解析输入的视频连接
- (IBAction)onClickParseVideo:(id)sender {
    
    //https://www.youtube.com/watch?v=9kBHUMSSkF8 30s Apple广告
    //https://www.youtube.com/watch?v=0QRVXnZkr1Y 几分钟演唱会歌曲
    NSString *urlStr = self.textField.text;
    [self.viewModel parseVideoWithURLString: urlStr shouldShowPanel: SHOULD_SHOW_PANEL];
}

// 点击查看已下载文件夹
- (IBAction)onClickFolder:(id)sender {
    [self.viewModel openMp4FileController: self];
}

// 点击跳转浏览器选取下载链接
- (IBAction)onClickBrowser:(id)sender {
    [self.viewModel openBrowser: self onURLChange:^(NSURL *webURL) {
        self.textField.text = webURL.absoluteString;
        [self.viewModel parseVideoWithURLString: self.textField.text  shouldShowPanel: SHOULD_SHOW_PANEL];
    }];
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
        self.browserButton.enabled = NO;
        self.folderButton.enabled = NO;
    });
}

-(void)unlockButtons {
    dispatch_async(MAIN_QUEUE, ^{
        self.updateButton.enabled = YES;
        self.parseButton.enabled = YES;
        self.folderButton.enabled = YES;
        self.browserButton.enabled = YES;
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing: YES];
}

@end

