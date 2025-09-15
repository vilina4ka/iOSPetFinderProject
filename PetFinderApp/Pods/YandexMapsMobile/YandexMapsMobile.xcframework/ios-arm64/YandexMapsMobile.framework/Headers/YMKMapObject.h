#import <YandexMapsMobile/YMKAnimation.h>
#import <YandexMapsMobile/YMKCallback.h>
#import <YandexMapsMobile/YMKMapObjectDragListener.h>
#import <YandexMapsMobile/YMKMapObjectTapListener.h>

@class YMKBaseMapObjectCollection;

/**
 * An object displayed on the map.
 */
@interface YMKMapObject : NSObject
/**
 * Returns the collection of map objects that the current map object
 * belongs to.
 */
@property (nonatomic, readonly, readonly, nonnull) YMKBaseMapObjectCollection *parent;
/**
 * Manages visibility of the object on the map. Default: true.
 */
@property (nonatomic, getter=isVisible) BOOL visible;

/**
 * Manages visibility of the object.
 *
 * @param animation Describes the transition between visible and not
 * visible states.
 * @param onFinished Called when the transition is finished.
 */
- (void)setVisibleWithVisible:(BOOL)visible
                    animation:(nonnull YMKAnimation *)animation
                     callback:(nullable YMKCallback)callback;
/**
 * Gets the z-index, which affects: <ul><li>Rendering order.</li>
 * <li>Dispatching of UI events (taps and drags are dispatched to
 * objects with higher z-indexes first).</li></ul> Z-index is relative
 * to the parent.
 */
@property (nonatomic) float zIndex;
/**
 * If true, the map object can be dragged by the user. Default: false.
 */
@property (nonatomic, getter=isDraggable) BOOL draggable;
/**
 * Use this property to attach any object-related metadata.
 *
 * Optional property, can be nil.
 */
@property (nonatomic, nullable) id userData;

/**
 * Adds a tap listener to the object.
 *
 * The class does not retain the object in the 'tapListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)addTapListenerWithTapListener:(nonnull id<YMKMapObjectTapListener>)tapListener;

/**
 * Removes the tap listener from the object.
 */
- (void)removeTapListenerWithTapListener:(nonnull id<YMKMapObjectTapListener>)tapListener;

/**
 * Sets a drag listener for the object. Each object can only have one
 * drag listener.
 *
 * The class does not retain the object in the 'dragListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)setDragListenerWithDragListener:(nullable id<YMKMapObjectDragListener>)dragListener;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
