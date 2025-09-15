#import <YandexMapsMobile/YMKTrafficListener.h>

/**
 * A layer with traffic information.
 */
@interface YMKTrafficLayer : NSObject

/**
 * Checks if traffic is visible.
 */
- (BOOL)isTrafficVisible;

/**
 * Sets traffic visibility.
 */
- (void)setTrafficVisibleWithOn:(BOOL)on;

/**
 * Applies JSON style transformations to the traffic layer. Same as
 * setTrafficStyle(0, style). Set to empty string to clear previous
 * styling. Returns true if the style was successfully parsed; false
 * otherwise. If the return value is false, the current traffic style
 * remains unchanged.
 */
- (BOOL)setTrafficStyleWithStyle:(nonnull NSString *)style;

/**
 * Applies JSON style transformations to the traffic layer. Replaces
 * previous styling with the specified ID (if such exists). Stylings are
 * applied in an ascending order. Set to empty string to clear previous
 * styling with the specified ID. Returns true if the style was
 * successfully parsed; false otherwise. If the return value is false,
 * the current traffic style remains unchanged.
 */
- (BOOL)setTrafficStyleWithId:(NSInteger)id
                        style:(nonnull NSString *)style;

/**
 * Resets all JSON style transformations applied to the traffic layer.
 */
- (void)resetTrafficStyles;

/**
 * Adds a traffic listener.
 *
 * The class does not retain the object in the 'trafficListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)addTrafficListenerWithTrafficListener:(nonnull id<YMKTrafficDelegate>)trafficListener;

/**
 * Removes a traffic listener.
 */
- (void)removeTrafficListenerWithTrafficListener:(nonnull id<YMKTrafficDelegate>)trafficListener;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
