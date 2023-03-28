//
//  FileOperation.m
//  Example
//
//  Created by kaoji on 3/26/23.
//

#import "VideoOperation.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation VideoOperation
+ (void)showActionSheetWithURL:(NSURL *)url inController:(UIViewController *)controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择处理方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self playVideoWithURL:url inController:controller];
    }];
    
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"共享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareVideoWithURL:url inController:controller];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:playAction];
    [alertController addAction:shareAction];
    [alertController addAction:cancelAction];
    
    [controller presentViewController:alertController animated:YES completion:nil];
}

+ (void)playVideoWithURL:(NSURL *)url inController:(UIViewController *)controller {
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = [AVPlayer playerWithURL:url];
    [controller presentViewController:playerViewController animated:YES completion:^{
        [playerViewController.player play];
    }];
}

+ (void)shareVideoWithURL:(NSURL *)url inController:(UIViewController *)controller {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    [controller presentViewController:activityViewController animated:YES completion:nil];
}

@end
