//
//  MP4FileController.m
//  Example
//
//  Created by kaoji on 3/26/23.
//

#import "MP4FileController.h"
#import "VideoOperation.h"

@interface MP4FileController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *emptyView;
@property (strong, nonatomic) NSArray<NSString *> *mp4Files;
@property (strong, nonatomic) NSURL *directoryURL;

@end

@implementation MP4FileController

- (instancetype)initWithDirectoryURL:(NSURL *)directoryURL {
    self = [super initWithNibName:@"MP4FileController" bundle:nil];
    if (self) {
        self.directoryURL = directoryURL;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已下载";
    
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // 添加空视图
    self.emptyView = [[[NSBundle mainBundle] loadNibNamed:@"EmptyFiles" owner:self options:nil] firstObject];
    self.tableView.backgroundView = self.emptyView;
    self.emptyView.hidden = (_mp4Files.count > 0);
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapped)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

-(void)leftBarButtonTapped{
    [self.navigationController popViewControllerAnimated: YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mp4Files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.mp4Files[indexPath.row];
    cell.imageView.image = [UIImage imageNamed: @"mp4"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSURL *videoURL = [self.directoryURL URLByAppendingPathComponent:self.mp4Files[indexPath.row]];
    [VideoOperation showActionSheetWithURL: videoURL inController: self];
}

@end
