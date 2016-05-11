# ZHToast
ZHToast is a simple iOS toast view, it can be used to show text message or HUD on device screen. ZHToastView provides multiple kinds of features and easy to use.

## Requirement
ZHToast works on iOS 6+ and requires ARC to build. It depends on below Apple frameworks:
  * UIKit.framework
  * Foundation.framework

## CocoaPods
`platform :ios, '6.0'`

`pod 'ZHToast', '~> 0.0.1'`


if this doesn't work, then directly add pod entry like this:

`platform :ios, '6.0'`

`pod 'ZHToast', :git => 'https://github.com/mrarronz/ZHToast.git', :tag => '0.0.1'`


## Manually
Drag the folder ZHToast to your own project and import ZHToastView.h in the class file.

## Usage
The example project provides multiple ways to use the ZHToast. Following is the screenshot and usage code:

1、Hint

![image](https://github.com/mrarronz/ZHToast/raw/master/screenshot/hint.png)

Hint is the most normal style, we often use it to show a text message only with a label. you can use it like this:

```objective-c
ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleHint];
toast.parentView = self.view;
toast.toastAnim = ZHToastAnimationFade;
toast.labelText = @"Hello Animation~~";
toast.automaticallyHide = YES;
[toast show];
```

or simply use the Class method:

```objective-c
[ZHToastView showToast:@"Hello world!"];
```

2、Image

![image](https://github.com/mrarronz/ZHToast/raw/master/screenshot/text_image.png)

Image style is showing a text with an icon, sometimes we may need to show a success message to user after completing a task successfully. Below is the sample code:

```objective-c
ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleImage];
toast.parentView = self.view;
toast.toastAnim = ZHToastAnimationLinear;
toast.labelText = @"Mission Complete";
toast.image = [UIImage imageNamed:@"success"];
toast.automaticallyHide = YES;
[toast show];
```
or you can simply use it like this:

```objective-c
[ZHToastView showToast:@"Data downloaded" image:[UIImage imageNamed:@"success"]];
```

3、HUD

![image](https://github.com/mrarronz/ZHToast/raw/master/screenshot/hud_text.png)
![image](https://github.com/mrarronz/ZHToast/raw/master/screenshot/hud_no_text.png)

The HUD style shows a loading message with an indicator, call this method when you have tasks executed in the background thread.

```objective-c
ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleHUD];
toast.parentView = self.view;
toast.bkgColor = [UIColor purpleColor];
toast.automaticallyHide = YES;
[toast show];
```

4、Show in NavigationBar

![image](https://github.com/mrarronz/ZHToast/raw/master/screenshot/navigationbar.png)

This UI style simulated the pop message in the app [Zaker](http://itunes.apple.com/us/app/zaker/id410174232?mt=8)

```objective-c
ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleNavBar];
toast.labelText = @"Successfully loaded";
toast.bkgColor = [UIColor colorWithRed:0.222 green:0.777 blue:0.222 alpha:1.0];
toast.automaticallyHide = YES;
[toast show];
```

5、Loading

![image](https://github.com/mrarronz/ZHToast/raw/master/screenshot/loading.png)

Loading style is different from HUD, the indicator is displayed on left of the text label. I prefer to use it with loading a webview.

```objective-c
ZHToastView *toast = [[ZHToastView alloc] initWithStyle:ZHToastStyleLoading];
toast.parentView = self.view;
toast.labelText = @"Loading, please wait...";
toast.automaticallyHide = YES;
[toast show];
```

ZHToast provides multiple properties to customize the UI. Suggest to use any toast or HUD with an objective-c category, for example, you can create a UIView category named 'UIView+Toast'(whatever), encapsulate all the usage methods in the category.

```objective-c
- (void)toast:(NSString *)text;
```

in the view you want to display it, just do it like below:

```objective-c
[self.view toast:@"Yes, this is awesome!"];
```

## License
This code is distributed under the terms and conditions of the [MIT license](LICENSE).
