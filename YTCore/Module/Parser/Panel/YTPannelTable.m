//
//  YTPannelTable.m
//  YTCore
//
//  Created by kaoji on 3/14/23.
//

#import <UIKit/UIKit.h>
#import "YTPanelHead.h"
#import "YTPanelCell.h"
#import "YTPannelTable.h"
#import "UIButton+Block.h"

@interface YTPannelTable()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation YTPannelTable
{
    YTVideoListModel *_trackList;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.estimatedRowHeight = 50;
        self.rowHeight = UITableViewAutomaticDimension;
        self.dataSource = self;
        self.delegate = self;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 10);
        gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor];
        gradientLayer.locations = @[@0, @1];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gradientLayer.frame.size.width, 10)];
        [headerView.layer addSublayer:gradientLayer];
        [self.tableHeaderView addSubview:headerView];

        
        // 注册 YTPanelCell
        [self registerClass:[YTPanelCell class] forCellReuseIdentifier:@"YTPanelCell"];
    }
    return self;
}

-(void)configWithModel:(YTVideoListModel *)trackList{
    _trackList = trackList;
    
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 返回 cell 的数量
    return _trackList.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建并返回 YTPanelCell
    YTVideo *track = _trackList.tracks[indexPath.row];
    YTPanelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTPanelCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = track.resolution;
    cell.detailTextLabel.text = track.size;
    cell.imageView.image = [self imageNamedFromYTCoreBundle: (track.pureVideo ?@"mp4":@"mux")];
    __weak typeof(self) weakSelf = self;
    [cell.downloadButton addActionHandler:^(NSInteger tag) {
        if (weakSelf.trackCallback){
            weakSelf.trackCallback(track);
        }
    }];
    return cell;
}

-(void)onClickMedia{
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  54;
}

- (UIImage *)imageNamedFromYTCoreBundle:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"YTCore" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    UIImage *image = [UIImage imageNamed:name inBundle:imageBundle compatibleWithTraitCollection:nil];
    return image;
}
@end
