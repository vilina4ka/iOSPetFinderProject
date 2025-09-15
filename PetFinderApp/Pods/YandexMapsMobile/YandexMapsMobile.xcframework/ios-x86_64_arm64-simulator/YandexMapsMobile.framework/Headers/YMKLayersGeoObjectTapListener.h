#import <Foundation/Foundation.h>

@class YMKGeoObjectTapEvent;

/**
 * Retrieves the brief geoObject info when an object is tapped.
 */
@protocol YMKLayersGeoObjectTapListener <NSObject>

/**
 * Listener that retrieves brief geoObject info for the tapped object.
 * Returns false if the event wasn't handled. The event will be
 * propagated to the map.
 */
- (BOOL)onObjectTapWithEvent:(nonnull YMKGeoObjectTapEvent *)event;

@end
