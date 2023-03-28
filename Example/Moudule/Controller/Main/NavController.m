//
//  NavController.m
//  Example
//
//  Created by kaoji on 3/26/23.
//

#import "NavController.h"

@interface NavController ()

@end

@implementation NavController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *barAppearance = [UINavigationBar appearance];
    barAppearance.translucent = NO;
    barAppearance.clipsToBounds = NO;

    NSDictionary<NSAttributedStringKey, id> *titleTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor blackColor],
    };

    if (@available(iOS 15, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.titleTextAttributes = titleTextAttributes;

        barAppearance.standardAppearance = appearance;
        barAppearance.scrollEdgeAppearance = appearance;
    } else {
        [barAppearance setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefaultPrompt];
        [barAppearance setShadowImage:[UIImage new]];
        barAppearance.barTintColor = [UIColor blackColor];
        barAppearance.titleTextAttributes = titleTextAttributes;
    }
    barAppearance.tintColor = [UIColor whiteColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
