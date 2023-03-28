//
//  ErrorTextField.m
//  Example
//
//  Created by kaoji on 3/27/23.
//

#import "ErrorTextField.h"

@implementation ErrorTextField

- (instancetype)initWithCoder:(NSCoder *)coder{
    if(self = [super initWithCoder: coder]){
        self.delegate = self;
    }
    return  self;
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
        NSString *videoKey = [self getYouTubeVideoKeyFromURL: url.path];
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

// 从YT网址中提取videoId
- (NSString *)getYouTubeVideoKeyFromURL:(NSString *)urlString {
    NSError *error = NULL;
    
    // 创建正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=watch\\?v=|/videos/|embed\\/)[^#\\&\\?]*" options:NSRegularExpressionCaseInsensitive error:&error];
    
    // 匹配视频 key
    NSTextCheckingResult *match = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
    
    // 返回视频 key
    if (match) {
        NSString *videoKey = [urlString substringWithRange:match.range];
        return videoKey;
    } else {
        return nil;
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if(self.errorLabel){
        self.errorLabel.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) + 5, CGRectGetWidth(self.frame), 12);
    }
    
}
@end
