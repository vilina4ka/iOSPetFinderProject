#import <YandexMapsMobile/YRTLifecycleListener.h>

/// :nodoc:
@protocol YRTLifecycleProvider

- (void)setListener:(__weak id<YRTLifecycleListener>)listener;
- (void)reset;
- (bool)isActive;

@end
