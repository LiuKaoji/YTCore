//
//  UIViewController+Alert.h
//  Example
//
//  Created by kaoji on 3/26/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alert)
- (void)showAlertWithConfirmation:(NSString *)title message:(NSString *)message confirmationHandler:(void (^)(void))handler;
- (void)showMessage:(NSString *)title message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
