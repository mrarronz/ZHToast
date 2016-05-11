//
//  UIView+Toast.m
//  Example
//
//  Created by Arron Zhu on 16/5/10.
//  Copyright © 2015年 arronz. All rights reserved.
//

#import "UIView+Toast.h"
#import "ZHToastView.h"

@implementation UIView (Toast)

- (void)toast:(NSString *)text {
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleHint];
    toast.parentView = self;
    toast.labelText = text;
    toast.offsetY = CGRectGetHeight(self.bounds)/4 + 20; // for ViewController's view
    toast.automaticallyHide = YES;
    [toast show];
    
    // or simply use below code:
//    [ZHToastView showToast:text
//                    offset:CGRectGetHeight(self.bounds)/4 + 20
//                  duration:1.0
//                     style:ZHToastStyleHint];
}

@end
