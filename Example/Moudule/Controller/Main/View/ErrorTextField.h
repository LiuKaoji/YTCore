//
//  ErrorTextField.h
//  Example
//
//  Created by kaoji on 3/27/23.
//

#import <UIKit/UIKit.h>

// 声明一个用于 URL 验证的 block 回调，参数为当前 URL 是否有效的 BOOL 类型值
typedef BOOL (^YouTubeURLValidationBlock)(BOOL isValid);

@interface ErrorTextField : UITextField

// 错误提示标签
@property (nonatomic, strong) UILabel *errorLabel;

// URL 验证回调
@property (nonatomic, copy) YouTubeURLValidationBlock validateBlock;

// 显示错误提示
- (void)showError:(NSString *)message;

// 隐藏错误提示
- (void)hideError;

@end


