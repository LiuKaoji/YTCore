//
//  YTCLogView.m
//  Example
//
//  Created by kaoji on 3/13/23.
//


#import "YTCLogView.h"

#define kLogViewHeight 150
#define kMaxLogs 300

@interface YTCLogView()

@property (nonatomic, strong) NSMutableArray *logs;

@end

@implementation YTCLogView{
    //NSDateFormatter *_dateFormatter;
    NSDictionary * _attributes;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    _logs = [NSMutableArray array];
//    _dateFormatter = [[NSDateFormatter alloc] init];
//    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; paragraphStyle.lineSpacing = 4;
    _attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10], NSParagraphStyleAttributeName: paragraphStyle};
    self.font = [UIFont systemFontOfSize:10];
//    self.textContainerInset = UIEdgeInsetsMake(20, 10, 10, 20);
//    self.contentInset = UIEdgeInsetsMake(20, 10, 10, 20);
    
    
}

- (void)logMessage:(NSString *)message withLevel:(DebugLevel)level color:(UIColor *)color {
    if (!message) {
        return;
    }
    
    NSString *levelStr = nil;
    switch (level) {
        case DebugLevelD:
            levelStr = @"[D]";
        case DebugLevelW:
            levelStr = @"[W]";
        case DebugLevelE:
            levelStr = @"[E]";
        default:
            levelStr = @"";
    }
    NSString *log = [NSString stringWithFormat:@"%@%@", levelStr, message];
    


    NSMutableAttributedString *attributedLog = [[NSMutableAttributedString alloc] initWithString:log attributes: _attributes];
    [attributedLog addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, log.length)];
    [attributedLog appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    [self appendAttributedText:attributedLog];
}

- (void)d:(NSString *)msg {
    UIColor *dColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:1.0];
    [self logMessage:msg withLevel:DebugLevelD color:dColor];
}

- (void)w:(NSString *)msg {
    UIColor *wColor = [UIColor colorWithRed:238/255.0 green:177/255.0 blue:59/255.0 alpha:1.0];
    [self logMessage:msg withLevel:DebugLevelW color:wColor];
}

- (void)e:(NSString *)msg {
    UIColor *eColor = [UIColor colorWithRed:197/255.0 green:70/255.0 blue:47/255.0 alpha:1.0];
    [self logMessage:msg withLevel:DebugLevelE color:eColor];
}

- (void)appendAttributedText:(NSAttributedString *)attributedText {
    if (!attributedText) {
        return;
    }
    NSMutableAttributedString *mutableAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [mutableAttributedText appendAttributedString:attributedText];
    self.attributedText = mutableAttributedText;
    [self scrollRangeToVisible:NSMakeRange(self.text.length, 0)];
}

- (void)logMessage:(NSString *)message withColor:(UIColor *)color {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message];
        [attributedMessage addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedMessage.length)];
        
        NSMutableAttributedString *logText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        [logText appendAttributedString:attributedMessage];
        [logText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        
        self.attributedText = logText;
        
        [self scrollRangeToVisible:NSMakeRange(logText.length, 0)];
    });
}

- (void)clearLogs {
    [self.logs removeAllObjects];
    self.text = @"";
}

@end
