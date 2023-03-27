//
//  YTPanelCell.m
//  YTCore
//
//  Created by kaoji on 3/14/23.
//

#import "YTPanelCell.h"

@interface YTPanelCell ()


@end

@implementation YTPanelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建下载按钮
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"YTCore" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        UIImage *downloadImage = [UIImage imageNamed:@"download" inBundle:imageBundle compatibleWithTraitCollection:nil];
        
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.translatesAutoresizingMaskIntoConstraints = NO;
        _downloadButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [_downloadButton setImage:downloadImage  forState: UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(downloadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_downloadButton];
        
        // 添加约束
        [NSLayoutConstraint activateConstraints:@[
            [_downloadButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
            [_downloadButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [_downloadButton.widthAnchor constraintEqualToConstant: 40],
        ]];
    }
    return self;
}

- (void)downloadButtonTapped:(id)sender {
    // TODO: 处理下载按钮点击事件
}

@end
