//
//  SecondViewController.m
//  Example
//
//  Created by Arron Zhu on 16/5/10.
//  Copyright © 2015年 arronz. All rights reserved.
//

#import "SecondViewController.h"
#import "ZHToastView.h"

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *hideButton = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClicked:)];
    
    UIBarButtonItem *showButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[showButton, hideButton];
    
    [self.textField becomeFirstResponder];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)leftButtonClicked:(id)sender {
    UIWindow *window = [ZHToastView theKeyWindow];
    [ZHToastView hideAllToastsForView:window];
}

- (void)rightButtonClicked:(id)sender {
    UIWindow *window = [ZHToastView theKeyWindow];
    [ZHToastView hideAllToastsForView:window];
    ZHToastView *toast = [[ZHToastView alloc] initWithView:window];
    toast.labelText = @"Message on keyboard!!!";
    toast.offsetY = 150;
    [toast show];
}

@end
