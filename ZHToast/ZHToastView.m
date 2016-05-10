//
//  ZHToastView.m
//  Version 0.1
//  Copyright © 2015年 arronz. All rights reserved.
//

#import "ZHToastView.h"
#import "UIView+Frame.h"

/// Default padding of label and toast.
static const CGFloat kPadding = 10;

/// Padding of label when the labelText = nil.
static const CGFloat kLabelMargin = 25;

/// Default label font.
static const CGFloat kDefaultLabelFont = 15;

/// The height of navigation bar and status bar in iOS7.
static const CGFloat kTopBarHeight = 64;

/// Navigation bar height.
static const CGFloat kNavigationBarHeight = 44;

/// Default duration of toast displayed.
static const NSTimeInterval kDefaultDuration = 2.0f;

/// Default Animation duration.
static const NSTimeInterval kAnimationDuration = 0.25f;

/// Default opacity
static const float kDefaultOpacity = 0.7;

/// Default corner radius.
static const float kDefaultRadius = 6.0;


#define UI_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UI_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define kMaxHeight 100

@interface ZHToastView () {
    CGSize _imageSize;
    BOOL _animated;
}

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *overlayView;

- (CGSize)textSize;
- (CGSize)textSizeWithFont;
- (CGPoint)positionInParentView;

@end

@implementation ZHToastView

#pragma mark - Class methods

+ (void)showToast:(NSString *)text {
    [self showToast:text duration:kDefaultDuration style:ZHToastStyleHint];
}

+ (void)showToast:(NSString *)text image:(UIImage *)image {
    [self showToast:text image:image duration:kDefaultDuration];
}

+ (void)showToast:(NSString *)text image:(UIImage *)image duration:(NSTimeInterval)duration {
    // Hide all toasts in keywindow.
    UIWindow *keyWindow = [self theKeyWindow];
    [self hideAllToastsForView:keyWindow];
    
    // Show image toast
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleImage];
    toast.labelText = text;
    toast.image = image;
    toast.parentView = [UIApplication sharedApplication].keyWindow;
    toast.automaticallyHide = YES;
    toast.duration = duration;
    [toast show];
}

+ (void)showToast:(NSString *)text duration:(NSTimeInterval)duration {
    [self showToast:text duration:duration style:ZHToastStyleHint];
}

+ (void)showToast:(NSString *)text duration:(NSTimeInterval)duration style:(ZHToastStyle)toastStyle {
    // show toast in the center of superview.
    [self showToast:text offset:0 duration:duration style:toastStyle];
}

+ (void)showToast:(NSString *)text offset:(CGFloat)offsetY duration:(NSTimeInterval)duration style:(ZHToastStyle)toastStyle {
    if (toastStyle == ZHToastStyleImage) {
        return;
    }
    // Hide all toasts in keywindow.
    UIWindow *keyWindow = [self theKeyWindow];
    [self hideAllToastsForView:keyWindow];
    
    // Show new toast.
    ZHToastView *toast = [[ZHToastView alloc] initWithStyle:toastStyle];
    toast.labelText = text;
    toast.offsetY = offsetY;
    toast.parentView = keyWindow;
    toast.automaticallyHide = YES;
    toast.duration = duration;
    [toast show];
}

+ (NSArray *)toastForView:(UIView *)view {
    NSMutableArray *toasts = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [toasts addObject:aView];
        }
    }
    return [NSArray arrayWithArray:toasts];
}

+ (NSUInteger)hideAllToastsForView:(UIView *)view {
    NSArray *toasts = [ZHToastView toastForView:view];
    [toasts makeObjectsPerformSelector:@selector(removeFromSuperview)];
    return [toasts count];
}

+ (UIWindow *)theKeyWindow {
    UIWindow *window = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        window = [[UIApplication sharedApplication].delegate window];
    }
    // For keyboard above iOS 9
    for (UIWindow *seprateWindow in [UIApplication sharedApplication].windows) {
        if ([seprateWindow isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            window = seprateWindow;
            break;
        }
    }
    if(window == nil) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

#pragma mark - Life Cycle

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        self.toastStyle = ZHToastStyleHint;
        self.toastAnim = ZHToastAnimationNone;
        self.parentView = view;
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(ZHToastStyle)style {
    return [self initWithStyle:style animation:ZHToastAnimationNone];
}

- (instancetype)initWithStyle:(ZHToastStyle)style animation:(ZHToastAnimation)anim {
    self = [super init];
    if (self) {
        self.toastStyle = style;
        
        // Set different animation style according to the toast style.
        if (style == ZHToastStyleNavBar) {
            self.toastAnim = ZHToastAnimationLinear;
        } else if (style == ZHToastStyleLoading || style == ZHToastStyleHUD) {
            self.toastAnim = ZHToastAnimationZoom;
        } else {
            self.toastAnim = anim;
        }
        [self setup];
    }
    return self;
}

- (void)setup {
    self.bkgColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.labelColor = [UIColor whiteColor];
    self.labelFont = [UIFont systemFontOfSize:kDefaultLabelFont];
    self.labelText = nil;
    self.toastRadius = kDefaultRadius;
    self.opacity = kDefaultOpacity;
    self.duration = kDefaultDuration;
    self.isRoundedCorner = NO;
    self.automaticallyHide = NO;
    _imageSize = CGSizeMake(20.f, 20.f);
    self.offsetY = 0.f;
    
    self.backgroundColor = self.bkgColor;
    self.textLabel.textColor = self.labelColor;
    self.textLabel.font = self.labelFont;
    self.textLabel.text = self.labelText;
    
    [self updateUIWithStyle];
    [self registerKVO];
}

#pragma mark - Private

- (CGSize)textSize {
    CGFloat width = (self.view_width - kPadding*2 > 0) ? self.view_width - kPadding*2: self.view_width;
    CGFloat height = MIN(self.view_height, kMaxHeight);
    if (iOS7) {
        return [self.textLabel.text boundingRectWithSize:CGSizeMake(width, height)
                                                 options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName : self.labelFont, NSForegroundColorAttributeName : self.labelColor}
                                                 context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self.textLabel.text sizeWithFont:self.labelFont
                        constrainedToSize:CGSizeMake(width, height)
                            lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
    }
}

- (CGSize)textSizeWithFont {
    if (iOS7) {
        return [self.textLabel.text sizeWithAttributes:@{NSFontAttributeName : self.labelFont}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self.textLabel.text sizeWithFont:self.labelFont];
#pragma clang diagnostic pop
    }
}

/**
 *  Get the position in superview. Default is the center point.
 */
- (CGPoint)positionInParentView {
    return CGPointMake(self.parentView.view_width/2, self.parentView.view_height/2 + self.offsetY);
}

#pragma mark - Init UI

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:kDefaultLabelFont];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] init];
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}

/**
 * Update the size of toast view.
 */
- (void)updateUIWithStyle {
    self.textLabel.view_size = [self textSizeWithFont];
    self.imageView.hidden = YES;
    [self.indicatorView stopAnimating];
    
    if (self.toastStyle == ZHToastStyleHint) {
        self.view_width = kPadding*2 + self.textLabel.view_width;
        self.view_height = kPadding*2 + self.textLabel.view_height;
    }
    else if (self.toastStyle == ZHToastStyleImage) {
        
        self.imageView.hidden = NO;
        
        CGFloat maxWidth = MAX(self.textLabel.view_width, _imageSize.width);
        self.view_width = kPadding*2 + maxWidth;
        self.view_height = kPadding*2 + self.textLabel.view_height + _imageSize.height + 5;
    }
    else if (self.toastStyle == ZHToastStyleLoading) {
        
        [self.indicatorView startAnimating];
        
        CGFloat maxHeight = MAX(self.indicatorView.view_height, self.textLabel.view_height);
        self.view_width = self.textLabel.view_width + self.indicatorView.view_width + kPadding*2 + 3;
        self.view_height = kPadding*2 + maxHeight;
    }
    else if (self.toastStyle == ZHToastStyleNavBar) {
        
        self.view_width = UI_SCREEN_WIDTH;
        self.view_height = iOS7 ? kTopBarHeight : kNavigationBarHeight;
    }
    else if (self.toastStyle == ZHToastStyleHUD) {
        
        [self.indicatorView startAnimating];
        
        CGFloat maxWidth = MAX(self.textLabel.view_width, self.indicatorView.view_width);
        if (self.labelText.length > 0) {
            self.view_width = kPadding*2 + maxWidth;
            self.view_height = kPadding*2 + self.textLabel.view_height + self.indicatorView.view_height + kPadding;
        } else {
            self.view_width = kLabelMargin*2 + maxWidth;
            self.view_height = kLabelMargin*2 + self.indicatorView.view_height;
        }
    }
}

- (void)dealloc {
    [self unregisterKVO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.toastStyle == ZHToastStyleHint) {
        self.textLabel.view_top = kPadding;
        self.textLabel.view_left = kPadding;
        self.textLabel.view_width = self.view_width - kPadding*2;
        self.textLabel.view_height = self.view_height - kPadding*2;
    }
    else if (self.toastStyle == ZHToastStyleImage) {
        self.imageView.view_top = kPadding + 3;
        self.imageView.view_size = _imageSize;
        self.imageView.view_centerX = self.view_width/2;
        
        self.textLabel.view_top = self.imageView.view_bottom + 3;
        self.textLabel.view_left = kPadding;
        self.textLabel.view_width = self.view_width - kPadding*2;
        self.textLabel.view_height = self.view_height - self.imageView.view_bottom - 3 - kPadding;
    }
    else if (self.toastStyle == ZHToastStyleLoading) {
        self.indicatorView.view_left = kPadding;
        self.indicatorView.view_centerY = self.view_height/2;
        self.textLabel.view_left = self.indicatorView.view_right + 3;
        self.textLabel.view_centerY = self.view_height/2;
        self.textLabel.view_width = self.view_width - self.textLabel.view_left - kPadding;
    }
    else if (self.toastStyle == ZHToastStyleNavBar) {
        self.textLabel.view_centerY = iOS7 ? self.view_height/2 + kPadding : self.view_height/2;
        self.textLabel.view_left = kPadding;
        self.textLabel.view_width = self.view_width - kPadding*2;
        self.textLabel.view_height = 20;
    }
    else if (self.toastStyle == ZHToastStyleHUD) {
        self.indicatorView.view_top = (self.labelText.length > 0) ? kPadding + 5 : kLabelMargin;
        self.indicatorView.view_centerX = self.view_width/2;
        self.textLabel.view_top = self.indicatorView.view_bottom + 5;
        self.textLabel.view_left = kPadding;
        self.textLabel.view_width = self.view_width - kPadding*2;
        self.textLabel.view_height = self.view_height - self.indicatorView.view_bottom - 5 - kPadding;
    }
}

#pragma mark - Show & Hide 

- (void)show {
    // If the style is 'ZHToastStyleNavBar', the parentView should be the keyWindow.
    if (self.toastStyle == ZHToastStyleNavBar) {
        self.parentView = [UIApplication sharedApplication].keyWindow;
    }
    NSAssert(self.parentView, @"ParentView cannot be nil! It's the superview of toast.");
    
    // Only when the style is 'ZHToastStyleHUD' the labelText can be nil.
    if (self.labelText.length == 0 && self.toastStyle != ZHToastStyleHUD) {
//        NSAssert(self.labelText.length, @"You forget to set text for textLabel!");
        return;
    }
    
    // Handle the situation that the toast width is bigger than that of its superview.
    if (self.view_width > self.parentView.view_width) {
        self.view_width = (self.parentView.view_width - kPadding*2 > 0) ? self.parentView.view_width - kPadding*2 : self.parentView.view_width;
        if (self.toastStyle == ZHToastStyleHint) {
            self.view_height = [self textSize].height + kPadding*2;
        }
        else if (self.toastStyle == ZHToastStyleImage) {
            self.view_height = [self textSize].height + kPadding*2 + _imageSize.height + 5;
        }
        else if (self.toastStyle == ZHToastStyleHUD) {
            self.view_height = [self textSize].height + kPadding*2 + self.indicatorView.view_height + kPadding;
        }
    }
    // Set corner radius of toast view.
    self.layer.cornerRadius = self.toastRadius;
    self.layer.masksToBounds = YES;
    
    _animated = (self.toastAnim != ZHToastAnimationNone);
    if (!_animated) {
        
        // Show toast without animation.
        if (self.toastStyle == ZHToastStyleImage) {
            NSAssert(self.image, @"image cannot be nil!(none animation)");
        }
        [self.parentView addSubview:self];
        self.center = [self positionInParentView];
        if (self.automaticallyHide) {
            [self hide];
        }
    } else {
        // Show toast with animation.
        switch (self.toastStyle) {
            case ZHToastStyleHint:
            {
                self.layer.cornerRadius = self.isRoundedCorner ? self.view_height/2 : self.toastRadius;
                self.layer.masksToBounds = YES;
                [self showWithAnimations];
            }
                
                break;
            case ZHToastStyleImage:
            {
                NSAssert(self.image, @"image cannot be nil!(animation)");
                [self showWithAnimations];
            }
                break;
            case ZHToastStyleLoading:
            case ZHToastStyleHUD:
                // Zoom
            {
                [self.parentView addSubview:self.overlayView];
                [self.parentView addSubview:self];
                self.overlayView.frame = self.parentView.bounds;
                self.center = [self positionInParentView];
                self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.5f, 1.5f));
                [UIView animateWithDuration:kAnimationDuration
                                 animations:^{
                                     self.transform = CGAffineTransformIdentity;
                                 } completion:^(BOOL finished) {
                                     if (self.automaticallyHide) {
                                         [self hide];
                                     }
                                 }];
            }
                break;
                
            case ZHToastStyleNavBar:
                // Linear
            {
                self.layer.cornerRadius = 0;
                [self.parentView addSubview:self];
                self.view_bottom = self.parentView.view_top;
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    self.view_top = self.parentView.view_top;
                } completion:^(BOOL finished) {
                    if (self.automaticallyHide) {
                        [self hide];
                    }
                }];
            }
                break;
            default:
                break;
        }
    }
}

- (void)showWithAnimations {
    
    if (self.toastAnim == ZHToastAnimationFade) {
        [self.parentView addSubview:self];
        self.center = [self positionInParentView];
        self.alpha = 0;
        [UIView animateWithDuration:kAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            if (self.automaticallyHide) {
                [self hide];
            }
        }];
    }
    else if (self.toastAnim == ZHToastAnimationLinear) {
        [self.parentView addSubview:self];
        
        // Set initial place of toast view according to offsetY.
        if ([self positionInParentView].y > self.parentView.view_height/2) {
            self.view_top = self.parentView.view_bottom;
        } else {
            self.view_bottom = self.parentView.view_top;
        }
        self.view_centerX = self.parentView.view_width/2;
        [UIView animateWithDuration:kAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            self.view_centerY = [self positionInParentView].y;
        } completion:^(BOOL finished) {
            CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
            shakeAnim.keyPath = @"transform.translation.y";
            shakeAnim.duration = kAnimationDuration;
            shakeAnim.values = @[@(0), @(-10), @(0)];
            [self.layer addAnimation:shakeAnim forKey:nil];
            if (self.automaticallyHide) {
                [self hide];
            }
        }];
    }
    else if (self.toastAnim == ZHToastAnimationZoom) {
        [self.parentView addSubview:self];
        self.center = [self positionInParentView];
        self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.5f, 1.5f));
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.automaticallyHide) {
                [self hide];
            }
        }];
    }
}

- (void)hide {
    if (!_animated) {
        [self performSelector:@selector(done) withObject:nil afterDelay:self.duration];
    } else {
        switch (self.toastStyle) {
            case ZHToastStyleHint:
            case ZHToastStyleImage:
            {
                [self hideWithAnimations];
            }
                break;
            case ZHToastStyleLoading:
            case ZHToastStyleHUD:
            {
                self.toastAnim = ZHToastAnimationZoom;
                [self hideWithAnimations];
            }
                break;
            case ZHToastStyleNavBar:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:kAnimationDuration
                                     animations:^{
                        self.view_bottom = self.parentView.view_top;
                    } completion:^(BOOL finished) {
                        [self done];
                    }];
                });
            }
                break;
            default:
                break;
        }
    }
}

- (void)hideWithAnimations {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.toastAnim == ZHToastAnimationFade) {
            [UIView animateWithDuration:kAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [self done];
                             }];
        }
        else if (self.toastAnim == ZHToastAnimationLinear) {
            [UIView animateWithDuration:kAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 if ([self positionInParentView].y > self.parentView.view_height/2) {
                                     self.view_top = self.parentView.view_bottom;
                                 } else {
                                     self.view_bottom = self.parentView.view_top;
                                 }
                             } completion:^(BOOL finished) {
                                 [self done];
                             }];
        }
        else if (self.toastAnim == ZHToastAnimationZoom) {
            [UIView animateWithDuration:kAnimationDuration
                             animations:^{
                                 self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(0.2f, 0.2f));
                             } completion:^(BOOL finished) {
                                 [self done];
                             }];
        }
    });
}

- (void)done {
    if (self.overlayView.superview) {
        [self.overlayView removeFromSuperview];
    }
    [self removeFromSuperview];
    if (self.completionBlock) {
        self.completionBlock();
        self.completionBlock = NULL;
    }
    if ([self.delegate respondsToSelector:@selector(toastViewDidHide:)]) {
        [self.delegate performSelector:@selector(toastViewDidHide:) withObject:self];
    }
}

#pragma mark - Block

- (void)showWithExecutingBlock:(dispatch_block_t)block
               completionBlock:(ZHToastCompletionBlock)completion {
    self.completionBlock = completion;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        block();
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hide];
        });
    });
    [self show];
}

- (void)hideWithCompletion:(ZHToastCompletionBlock)completion {
    self.completionBlock = completion;
    [self hide];
}

#pragma mark - KVO

- (void)registerKVO {
    for (NSString *keyPath in [self observedKeyPaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)unregisterKVO {
    for (NSString *keyPath in [self observedKeyPaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observedKeyPaths {
    return @[@"toastStyle", @"bkgColor", @"labelColor", @"labelFont", @"labelText", @"toastRadius", @"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeyPath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeyPath:keyPath];
    }
}

- (void)updateUIForKeyPath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"toastStyle"]) {
        if (self.toastStyle == ZHToastStyleNavBar) {
            self.toastAnim = ZHToastAnimationLinear;
        } else if (self.toastStyle == ZHToastStyleLoading || self.toastStyle == ZHToastStyleHUD) {
            self.toastAnim = ZHToastAnimationZoom;
        }
        [self updateUIWithStyle];
    }
    else if ([keyPath isEqualToString:@"bkgColor"]) {
        self.backgroundColor = self.bkgColor;
    }
    else if ([keyPath isEqualToString:@"labelColor"]) {
        self.textLabel.textColor = self.labelColor;
    }
    else if ([keyPath isEqualToString:@"labelFont"]) {
        self.textLabel.font = self.labelFont;
        [self updateUIWithStyle];
    }
    else if ([keyPath isEqualToString:@"labelText"]) {
        self.textLabel.text = self.labelText;
        [self updateUIWithStyle];
    }
    else if ([keyPath isEqualToString:@"toastRadius"]) {
        self.layer.cornerRadius = self.toastRadius;
    }
    else if ([keyPath isEqualToString:@"image"]) {
        self.imageView.image = self.image;
        _imageSize = self.image.size;
    }
}


@end
