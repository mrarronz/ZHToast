//
//  ViewController.m
//  Example
//
//  Copyright © 2015年 arronz. All rights reserved.
//

#import "ViewController.h"
#import "ZHToastView.h"
#import "UIView+Toast.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *options;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.options = @[
                     @[
                         @"Hint without animation",
                         @"Image without animation"
                         ],
                     @[
                         @"Hint with animation",
                         @"Image with animation",
                         @"Loading",
                         @"Navigationbar",
                         @"HUD + Text",
                         @"HUD"
                         ],
                     @[
                         @"Change corner radius",
                         @"Change Y position",
                         @"Change duration",
                         @"Show above keyboard",
                         @"Show with block",
                         ]
                     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.options.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.options objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier = @"cellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *title = [[self.options objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self showHintWithoutAnimation];
//            [self.view toast:@"hhhh和哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈和"];
        }
        else if (indexPath.row == 1) {
            [self showImageWithoutAnimation];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self showHintWithAnimation];
        }
        else if (indexPath.row == 1) {
            [self showImageWithAnimation];
        }
        else if (indexPath.row == 2) {
            [self showLoading];
        }
        else if (indexPath.row == 3) {
            [self showInNavigationBar];
        }
        else if (indexPath.row == 4) {
            [self showHUDWithText];
        }
        else if (indexPath.row == 5) {
            [self showHUD];
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self showWithCornerRadius];
        }
        else if (indexPath.row == 1) {
            [self showWithChangedPosition];
        }
        else if (indexPath.row == 2) {
            [self showWithDuration];
        }
        else if (indexPath.row == 3) {
            [self performSegueWithIdentifier:@"ShowDetails" sender:self];
        }
        else if (indexPath.row == 4) {
            [self showWithBlock];
        }
    }
}

- (void)showHintWithoutAnimation {
    [ZHToastView showToast:@"Hello world!"];
}

- (void)showImageWithoutAnimation {
    [ZHToastView showToast:@"Hello world!" image:[UIImage imageNamed:@"success"]];
}

- (void)showHintWithAnimation {
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleHint];
    toast.parentView = self.view;
    toast.toastAnim = ZHToastAnimationFade;
    toast.labelText = @"Hello Animation~~";
    toast.automaticallyHide = YES;
    [toast show];
}

- (void)showImageWithAnimation {
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleImage];
    toast.parentView = self.view;
    toast.toastAnim = ZHToastAnimationLinear;
    toast.labelText = @"Mission Complete";
    toast.image = [UIImage imageNamed:@"success"];
    toast.automaticallyHide = YES;
    [toast show];
}

- (void)showLoading {
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleLoading];
    toast.parentView = self.view;
    toast.labelText = @"Loading, please wait...";
    toast.automaticallyHide = YES;
    toast.labelFont = [UIFont boldSystemFontOfSize:16];
    [toast show];
}

- (void)showInNavigationBar {
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleNavBar];
    toast.labelText = @"Successfully loaded";
    toast.bkgColor = [UIColor colorWithRed:0.222 green:0.777 blue:0.222 alpha:1.0];
    toast.automaticallyHide = YES;
    [toast show];
}

- (void)showHUDWithText {
//    [ZHToastView showToast:@"Loading..." duration:3.0f style:ZHToastStyleHUD];
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleHUD];
    toast.parentView = self.view;
    toast.labelText = @"加载中...";
    toast.automaticallyHide = YES;
    toast.labelFont = [UIFont boldSystemFontOfSize:16];
    toast.bkgColor = [UIColor colorWithRed:0.777 green:0.222 blue:0.222 alpha:1.0];
    [toast show];
}

- (void)showHUD {
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleHUD];
    toast.parentView = self.view;
    toast.bkgColor = [UIColor purpleColor];
    toast.automaticallyHide = YES;
    [toast show];
}

- (void)showWithCornerRadius {
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleHint];
    toast.parentView = self.view;
    toast.labelText = @"来来来啦啦啦啦啦啦啦啦啦";
    toast.toastAnim = ZHToastAnimationFade;
    toast.isRoundedCorner = YES;
    toast.automaticallyHide = YES;
    [toast show];
}

- (void)showWithChangedPosition {
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleHint];
    toast.parentView = self.view;
    toast.labelText = @"How are you";
    toast.toastAnim = ZHToastAnimationLinear;
    toast.offsetY = 150;
    toast.automaticallyHide = YES;
    [toast show];
}

- (void)showWithDuration {
    [ZHToastView showToast:@"Loading..." duration:3.0f style:ZHToastStyleHUD];
}

- (void)showWithBlock {
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleHUD];
    toast.parentView = self.view;
    toast.bkgColor = [UIColor colorWithRed:0.135 green:0.236 blue:0.666 alpha:1.0];
    [toast showWithExecutingBlock:^{
        NSLog(@"Downloading data....");
    } completionBlock:^{
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Complete"
//                                                                       message:@"Data successfully downloaded."
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//        [self presentViewController:alert animated:YES completion:nil];
        [ZHToastView showToast:@"Data downloaded" image:[UIImage imageNamed:@"success"]];
    }];
}

@end
