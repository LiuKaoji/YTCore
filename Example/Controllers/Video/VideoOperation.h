//
//  FileOperation.h
//  Example
//
//  Created by kaoji on 3/26/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoOperation : NSObject
+ (void)showActionSheetWithURL:(NSURL *)url inController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
