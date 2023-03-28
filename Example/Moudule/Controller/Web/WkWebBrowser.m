//
//  WkWebBrowser.m
//  Example
//
//  Created by kaoji on 3/26/23.
//

#import "WkWebBrowser.h"
#import <WebKit/WebKit.h>
#import "UIViewController+Alert.h"

@interface WkWebBrowser () <WKNavigationDelegate>
@property (nonatomic, strong) NSURL *initialURL;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation WkWebBrowser

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.initialURL = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"浏览器";
    
    CGFloat safeAreaTop = self.view.safeAreaInsets.top;
    
    // Create the WKWebView
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = NO; // 禁止内联媒体播放
    config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    
    self.webView.navigationDelegate = self;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(safeAreaTop, 0, 0, 0);
    [self.view addSubview:self.webView];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create the toolbar buttons
    // Add left and right bar button items to the navigation bar
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapped)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTapped)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    // Create the progress view
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:self.progressView];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressView.progressTintColor = [UIColor blueColor];
    self.progressView.trackTintColor = [UIColor clearColor];
    
    // Create the overlay view
    self.overlayView = [[UIView alloc] initWithFrame:CGRectZero];
    self.overlayView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.overlayView.hidden = YES;
    [self.view addSubview:self.overlayView];
    self.overlayView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create the activity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    [self.overlayView addSubview:self.activityIndicator];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set up Auto Layout constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView, _progressView, _overlayView, _activityIndicator);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_progressView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_progressView(2)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_overlayView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_overlayView]|" options:0 metrics:nil views:views]];
    [self.overlayView addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_overlayView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.overlayView addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_overlayView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    NSURLRequest *request = [NSURLRequest requestWithURL: self.initialURL];
    [self.webView loadRequest:request];
}

-(void)leftBarButtonTapped{
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)rightBarButtonTapped{
    [self showActionSheet: nil];
}

- (void)showActionSheet:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *goBackAction = [UIAlertAction actionWithTitle:@"前进" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goBack];
    }];
    
    UIAlertAction *goForwardAction = [UIAlertAction actionWithTitle:@"后退" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goForward];
    }];
    
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refresh];
    }];
    
    UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([self getYouTubeURLFromVideoKey: self.webView.URL.absoluteString]){
            if(self.urlHandle){
                self.urlHandle(self.webView.URL);
                [self.navigationController popViewControllerAnimated: YES];
            }
        }else{
            [self showMessage:@"网址错误" message: @"当前网址非youtube播放页面"];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:goBackAction];
    [alertController addAction:goForwardAction];
    [alertController addAction:refreshAction];
    [alertController addAction:downloadAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// 拼合网址 可以避免传入列表网址 耗时过长
- (NSString *)getYouTubeURLFromVideoKey:(NSString *)videoKey {
    if (!videoKey || [videoKey isEqualToString:@""]) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", videoKey];
}

#pragma mark - Button Actions

- (void)goBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (void)goForward {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (void)refresh {
    [self.webView reload];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    [self.progressView setProgress:0.0 animated:NO];
    
    // Show the overlay view and start the activity indicator
    self.overlayView.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = YES;
    [self.progressView setProgress:0.0 animated:NO];
    
    // Hide the overlay view and stop the activity indicator
    self.overlayView.hidden = YES;
    [self.activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    [self.progressView setProgress:0.0 animated:NO];
    
    // Hide the overlay view and stop the activity indicator
    self.overlayView.hidden = YES;
    [self.activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    [self.progressView setProgress:0.0 animated:NO];
    
    // Hide the overlay view and stop the activity indicator
    self.overlayView.hidden = YES;
    [self.activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
}

@end
