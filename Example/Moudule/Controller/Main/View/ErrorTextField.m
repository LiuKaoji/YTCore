//
//  ErrorTextField.m
//  Example
//
//  Created by kaoji on 3/27/23.
//

#import "ErrorTextField.h"
#import "NSString+Youtube.h"

@implementation ErrorTextField

- (instancetype)initWithCoder:(NSCoder *)coder{
    if(self = [super initWithCoder: coder]){
        self.delegate = self;
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        clearButton.imageView.contentMode = UIViewContentModeCenter;
        [clearButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = clearButton;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
        
        self.placeholder = @"请输入youtube播放页链接";
    }
    return  self;
}

- (void)clearTextField {
    self.text = @"";
}

- (void)showError:(NSString *)message {
    if (!self.errorLabel) {
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)+5, CGRectGetWidth(self.frame), 12)];
        self.errorLabel.textColor = [UIColor redColor];
        self.errorLabel.font = [UIFont systemFontOfSize:10];
        [self.superview addSubview:self.errorLabel];
    }
    self.errorLabel.text = message;
}

- (void)hideError {
    [self.errorLabel removeFromSuperview];
    self.errorLabel = nil;
}

- (BOOL)isValidYouTubeURL:(NSURL *)url {
    NSString *host = url.host;
    if ([host isEqualToString:@"www.youtube.com"] || [host isEqualToString:@"youtube.com"]) {
        NSString *path = url.path;
        NSArray *pathComponents = [path componentsSeparatedByString:@"/"];
        NSString *videoKey = [NSString getYouTubeVideoKeyFromURL: url.path];
        if (pathComponents.count > 1 && [pathComponents[1] isEqualToString:@"watch"]) {
            if (!videoKey || [videoKey isEqualToString:@""] || videoKey.length < 10) {
                return NO;
            }
            return YES;
        }
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSURL *url = [NSURL URLWithString:textField.text];
    BOOL isValid = NO;
    if (url && [self isValidYouTubeURL:url]) {
        [self hideError];
        isValid = YES;
    } else {
        [self showError:@"⚠️youtube视频地址格式错误"];
        isValid = NO;
    }
    
    if(self.validateBlock){
        self.validateBlock(isValid);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if(self.errorLabel){
        self.errorLabel.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) + 5, CGRectGetWidth(self.frame), 12);
    }
    
}
@end
