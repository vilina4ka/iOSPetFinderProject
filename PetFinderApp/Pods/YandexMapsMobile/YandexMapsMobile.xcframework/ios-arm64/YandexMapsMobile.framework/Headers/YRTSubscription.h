#import <YandexMapsMobile/YRTNativeObject.h>

/// :nodoc:
typedef YRTNativeObject* (^YRTListenerFactory)(id);

/// :nodoc:
@interface YRTSubscription : NSObject

- (id)initWithKey:(void*)key factory:(YRTListenerFactory)factory;
- (YRTNativeObject *)getAssociatedWith:(id)listener;

@end
