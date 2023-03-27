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

@implementation YTCLogView

- (void)awakeFromNib{
    [super awakeFromNib];
    _logs = [NSMutableArray array];
    self.font = [UIFont systemFontOfSize:14];
    self.textContainerInset = UIEdgeInsetsMake(20, 10, 10, 20);
    self.contentInset = UIEdgeInsetsMake(20, 10, 10, 20);
}

- (void)d:(NSString *)msg{
    if(!msg){
        return;
    }
    NSString *dMsg = [@"[D]" stringByAppendingString:msg];
    [self logMessage:dMsg withColor:[UIColor greenColor]];
}

- (void)w:(NSString *)msg{
    if(!msg){
        return;
    }
    NSString *wMsg = [@"[W]" stringByAppendingString:msg];
    [self logMessage:wMsg withColor:[UIColor yellowColor]];
}

- (void)e:(NSString *)msg{
    if(!msg){
        return;
    }
    NSString *eMsg = [@"[E]" stringByAppendingString:msg];
    [self logMessage:eMsg withColor:[UIColor redColor]];
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
