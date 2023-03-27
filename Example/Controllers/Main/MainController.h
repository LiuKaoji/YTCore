//
//  MainController.h
//  Example
//
//  Created by kaoji on 3/13/23.
//

#import <UIKit/UIKit.h>
#import "YTCLogView.h"
#import "UIButton+BackgroundColor.h"
#import <YTCore/YTCore.h>

#define LOG_D(msg) [[MainController shared].logger d: msg]
#define LOG_W(msg) [[MainController shared].logger w: msg]
#define LOG_E(msg) [[MainController shared].logger e: msg]

NS_ASSUME_NONNULL_BEGIN

@interface MainController: UIViewController<YTCoreDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *parseButton;
@property (weak, nonatomic) IBOutlet UIButton *folderButton;
@property (weak, nonatomic) IBOutlet UIButton *browserButton;
@property (weak, nonatomic) IBOutlet YTCLogView *logger;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) YTCoreUtility *utility;
+(MainController*)shared;
@end

NS_ASSUME_NONNULL_END
