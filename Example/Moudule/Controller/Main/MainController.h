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
#import "ErrorTextField.h"

// 定义日志输出宏
#define LOG_D(msg) [[MainController shared].logger d: msg]
#define LOG_W(msg) [[MainController shared].logger w: msg]
#define LOG_E(msg) [[MainController shared].logger e: msg]

NS_ASSUME_NONNULL_BEGIN

@interface MainController: UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField; // 文本输入框
@property (weak, nonatomic) IBOutlet UIButton *updateButton; // 更新按钮
@property (weak, nonatomic) IBOutlet UIButton *parseButton; // 解析按钮
@property (weak, nonatomic) IBOutlet UIButton *folderButton; // 文件夹按钮
@property (weak, nonatomic) IBOutlet UIButton *browserButton; // 浏览器按钮
@property (weak, nonatomic) IBOutlet YTCLogView *logger; // 日志视图
@property (weak, nonatomic) IBOutlet UILabel *operationLabel; // 操作提示标签
@property (weak, nonatomic) IBOutlet ErrorTextField *urlTextField; // URL 文本输入框
+(MainController*)shared; // 获取单例对象

@end

NS_ASSUME_NONNULL_END
