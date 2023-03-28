//
//  WkWebBrowser.h
//  Example
//
//  Created by kaoji on 3/26/23.
//

#import <UIKit/UIKit.h>
typedef void(^URLBlock)(NSURL *webURL);
@interface WkWebBrowser : UIViewController
@property (nonatomic, copy) URLBlock urlHandle;
- (instancetype)initWithURL:(NSURL *)url;
@end
