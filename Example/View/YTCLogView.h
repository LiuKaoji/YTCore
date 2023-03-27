//
//  YTCLogView.h
//  Example
//
//  Created by kaoji on 3/13/23.
//

// YTCLogView.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTCLogView : UITextView
- (void)d:(NSString *)msg;
- (void)w:(NSString *)msg;
- (void)e:(NSString *)msg;
- (void)clearLogs;
@end

NS_ASSUME_NONNULL_END
