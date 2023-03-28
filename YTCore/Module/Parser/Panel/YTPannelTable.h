//
//  YTPanelTable.h
//  YTCore
//
//  Created by kaoji on 3/14/23.
//

#import <UIKit/UIKit.h>
#import "YTVideo.h"

typedef void (^YTPanelCellBlock)(YTVideo * _Nonnull track);
NS_ASSUME_NONNULL_BEGIN

@interface YTPanelTable : UITableView
@property (nonatomic, copy) YTPanelCellBlock trackCallback;
-(void)configWithModel:(YTVideoListModel *)trackList;
@end

NS_ASSUME_NONNULL_END
