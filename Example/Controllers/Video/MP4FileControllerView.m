//
//  MP4FileController.m
//  Example
//
//  Created by kaoji on 3/26/23.
//

#import "MP4FileController.h"
#import <AVKit/AVKit.h>

@interface MP4FileController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *mp4Files;
@property (strong, nonatomic) NSURL *directoryURL;

@end

@implementation MP4FileController

- (instancetype)initWithDirectoryURL:(NSURL *)directoryURL {
    self = [super initWithNibName:@"MP4FileManager" bundle:nil];
    if (self) {
        self.directoryURL = directoryURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取指定目录下的MP4文件列表
    NSError *error = nil;
    NSArray<NSString *> *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.directoryURL.path error:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    } else {
        self.mp4Files = [directoryContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mp4'"]];
    }
    
    // 设置UITableView数据源和委托
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mp4Files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.mp4Files[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 选中行时播放相应的MP4文件
    NSURL *videoURL = [self.directoryURL URLByAppendingPathComponent:self.mp4Files[indexPath.row]];
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:^{
        [player play];
    }];
}

@end
