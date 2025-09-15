#import <YandexMapsMobile/YRTLifecycleProvider.h>
#import <YandexMapsMobile/YRTLifecycleListener.h>
#import <Foundation/Foundation.h>

@interface YRTFlutterLifecycleProvider : NSObject <YRTLifecycleProvider>

- (void)onBackground;
- (void)onActivate;
- (void)setListener:(__weak id<YRTLifecycleListener>)listener;
- (void)reset;
- (bool)isActive;
- (void)initialize;

@end
