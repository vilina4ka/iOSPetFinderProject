#import <YandexMapsMobile/YMKPoint.h>

@class YMKMapObject;

/**
 * If an event is not handled by the source object then it's propagated
 * to its parent. This listener can be attached to any MapObject
 * including MapObjectCollection.
 */
@protocol YMKMapObjectTapListener <NSObject>

/**
 * Returns true if the event was handled. The event will not be
 * propagated to the parent. Returns false if the event wasn't handled.
 * The event will be propagated to the parent.
 */
- (BOOL)onMapObjectTapWithMapObject:(nonnull YMKMapObject *)mapObject
                              point:(nonnull YMKPoint *)point;

@end
