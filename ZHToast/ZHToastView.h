//
//  ZHToastView.h
//  Version 0.0.1
//  Copyright © 2015年 arronz. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2015 mrarronz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>
#import "UIView+Frame.h"

typedef NS_ENUM(NSInteger, ZHToastAnimation) {
    /** No animation. */
    ZHToastAnimationNone,
    
    /** Fade animation. */
    ZHToastAnimationFade,
    
    /** Show with zoom out animation and disappear with zoom in animation. */
    ZHToastAnimationZoom,
    
    /** Linear animation with changing vertical place. */
    ZHToastAnimationLinear
};

typedef NS_ENUM(NSInteger, ZHToastStyle) {
    /** Only show message with a label, support all kinds of animations. */
    ZHToastStyleHint,
    
    /** Show message with an icon, support all kinds of animations. */
    ZHToastStyleImage,
    
    /** Show loading message with UIActivityIndicatorView, only support zoom animation. */
    ZHToastStyleLoading,
    
    /** Show message beyond the navigation bar, only support linear animation. */
    ZHToastStyleNavBar,
    
    /** Show HUD message, only support zoom animation. */
    ZHToastStyleHUD
};


typedef void(^ZHToastCompletionBlock)();

@class ZHToastView;

@protocol ZHToastViewDelegate <NSObject>

@optional
/** 
 * Call this method after the toast view is fully hidden from its superview. 
 */
- (void)toastViewDidHide:(ZHToastView *)toastView;

@end


@interface ZHToastView : UIView

/**
 * The toastStyle of ZHToastView, change this property to show different UI style. Default style is 'ZHToastStyleHint'.
 *
 * @see ZHToastStyle
 */
@property (nonatomic, assign) ZHToastStyle toastStyle;

/**
 * The Animation style of ZHToastView, different UI style will show and hide with different animation. Default is 'ZHToastAnimationNone'.
 *
 * @see ZHToastAnimation.
 */
@property (nonatomic, assign) ZHToastAnimation toastAnim;

/**
 * The delegate object of ZHToastViewDelegate.
 *
 * @see ZHToastViewDelegate
 */
@property (nonatomic, assign) id<ZHToastViewDelegate> delegate;

/**
 * A block which is called after the toast is fully hidden.
 */
@property (nonatomic, copy) ZHToastCompletionBlock completionBlock;

/**
 * The superview of toast view, must be set a UIView object before you show toast. Default is nil.
 */
@property (nonatomic, assign) UIView *parentView;

/**
 * The background color of toast view. Default is black color with 0.7 alpha value.
 */
@property (nonatomic, strong) UIColor *bkgColor;

/**
 * The textColor of message label. Default is white color.
 */
@property (nonatomic, strong) UIColor *labelColor;

/**
 * The font of message label. Default is system font with 15 font size.
 */
@property (nonatomic, strong) UIFont *labelFont;

/**
 * The image on the toast when the style is 'ZHToastStyleImage', must be set an image before you show toast. Default is nil.
 */
@property (nonatomic, strong) UIImage *image;

/**
 * The corner radius of the toast layer. Default is 6.0f.
 */
@property (nonatomic, assign) float toastRadius;

/**
 * The opacity of the toast, will be used in drawing the background. Default is 0.7f.
 */
@property (nonatomic, assign) float opacity;

/**
 * The offset in y axis, change this value to make toast show in different postion vertically. Default is 0;
 */
@property (nonatomic, assign) CGFloat offsetY;

/**
 * The displayed duration of toast. Default is 2 seconds.
 */
@property (nonatomic, assign) NSTimeInterval duration;

/**
 * The text of message label. Default is nil. 
 *
 * @note Only when the toast style is 'ZHToastStyleHUD' you can let the labelText be nil, or you must set a string for it.
 */
@property (nonatomic, copy) NSString *labelText;

/**
 * whether the corner radius of toast is round (if YES, the corner radius equals half height of the toast). Default is NO.
 */
@property (nonatomic, assign) BOOL isRoundedCorner;

/**
 * whether the toast automatically hide after showing for a few seconds. Default is NO.
 */
@property (nonatomic, assign) BOOL automaticallyHide;

/**
 * Show toast with style 'ZHToastStyleHint'.
 *
 * @param text The toast message.
 */
+ (void)showToast:(NSString *)text;

/**
 * Show toast with style 'ZHToastStyleImage'.
 *
 * @see showToast:image:duration:
 */
+ (void)showToast:(NSString *)text image:(UIImage *)image;

/**
 * Show toast with style 'ZHToastStyleImage', the displayed duration can be changed.
 *
 * @param text The toast message.
 * @param image The image on toast.
 * @param duration How long the toast showed on its superview.
 */
+ (void)showToast:(NSString *)text image:(UIImage *)image duration:(NSTimeInterval)duration;

/**
 * Show toast with style 'ZHToastStyleHint', the displayed duration can be changed.
 *
 * @see showToast:duration:style:
 */
+ (void)showToast:(NSString *)text duration:(NSTimeInterval)duration;

/**
 * Show toast with a specified style, text and duration.
 *
 * @see showToast:offset:duration:style:
 */
+ (void)showToast:(NSString *)text duration:(NSTimeInterval)duration style:(ZHToastStyle)toastStyle;

/**
 * Show toast with a specified style, text and duration, the y position can be change by offsetY.
 *
 * @param text The toast message.
 * @param offsetY The y position in its superview.
 * @param duration How long the toast showed on its superview.
 * @param toastStyle The toast style.
 *
 * @note This method is not supported for style 'ZHToastStyleImage', if you want show image style, @see 'showToast:image:duration:'
 */
+ (void)showToast:(NSString *)text offset:(CGFloat)offsetY duration:(NSTimeInterval)duration style:(ZHToastStyle)toastStyle;

/**
 * Find all the toast in a view.
 *
 * @param view The superview of toast view.
 * @return An array of ZHToastView object.
 */
+ (NSArray *)toastForView:(UIView *)view;

/**
 * Get the count of toast view in the superview and hide all of them.
 * 
 * @param view The superview of toast view.
 * @return Count of ZHToastView object in a view.
 */
+ (NSUInteger)hideAllToastsForView:(UIView *)view;

/**
 * Find the top level window.
 *
 * @return An UIWindow object.
 */
+ (UIWindow *)theKeyWindow;

/**
 * Init the toast view with a given superview. The toast view will be displayed in the center of superview by default.
 *
 * @param view Superview of toast view, self.parentView = view.
 */
- (instancetype)initWithView:(UIView *)view;

/**
 * Init toast view with a given toast style, default animation is none.
 *
 * @see initWithStyle:animation:
 */
- (instancetype)initWithStyle:(ZHToastStyle)style;

/**
 * Init toast view with a given style and animation style.
 *
 * @param style Style of toast view.
 * @param anim Animation style of toast view.
 */
- (instancetype)initWithStyle:(ZHToastStyle)style animation:(ZHToastAnimation)anim;

/**
 * Show toast view, should be invoked in main thread. Once this method is called toast will not be hide unless you call hide or hideWithCompletion to hide toast manually.
 */
- (void)show;

/**
 * Hide toast view after you own logic is completed. This method will call the delegate method 'toastViewDidHide:' and the completionBlock.
 */
- (void)hide;

/**
 * Show toast view while a block is executing on a background queue, then hide the toast view.
 */
- (void)showWithExecutingBlock:(dispatch_block_t)block
               completionBlock:(ZHToastCompletionBlock)completion;

/**
 * Hide toast view with a block, it will call delegate 'toastViewDidHide' and completionBlock after toast is fully hidden.
 */
- (void)hideWithCompletion:(ZHToastCompletionBlock)completion;

@end
