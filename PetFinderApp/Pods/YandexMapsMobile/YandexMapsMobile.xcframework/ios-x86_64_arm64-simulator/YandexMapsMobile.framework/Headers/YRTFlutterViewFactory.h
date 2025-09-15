#import <UIKit/UIKit.h>
#import <YandexMapsMobile/YRTFlutterLifecycleProvider.h>

@interface YRTFlutterViewFactory: NSObject

+ (int64_t)getPlatformViewAddress:(UIView*)view;
+ (YRTFlutterLifecycleProvider*)createLifecycleProvider;
+ (UIView*)createPlatformView:(CGRect)frame
            lifecycleProvider:(YRTFlutterLifecycleProvider*)lifecycleProvider;
+ (void)startPlatformView:(UIView*)view
        lifecycleProvider:(YRTFlutterLifecycleProvider*)lifecycleProvider;

@end
