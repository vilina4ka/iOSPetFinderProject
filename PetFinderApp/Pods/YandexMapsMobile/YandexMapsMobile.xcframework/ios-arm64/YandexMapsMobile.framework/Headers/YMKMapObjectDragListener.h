#import <YandexMapsMobile/YMKPoint.h>

@class YMKMapObject;

/**
 * This listener is notified when a map object is being dragged. Note
 * that the map object's "draggable" property needs to be set to True in
 * order to activate dragging. A long tap on a map object activates
 * dragging mode.
 */
@protocol YMKMapObjectDragListener <NSObject>

/**
 * Raised when dragging mode is active for the given map object.
 */
- (void)onMapObjectDragStartWithMapObject:(nonnull YMKMapObject *)mapObject;

/**
 * Raised when the user is moving a finger and the map object follows
 * it.
 */
- (void)onMapObjectDragWithMapObject:(nonnull YMKMapObject *)mapObject
                               point:(nonnull YMKPoint *)point;

/**
 * Raised when the user released the tap.
 */
- (void)onMapObjectDragEndWithMapObject:(nonnull YMKMapObject *)mapObject;

@end
