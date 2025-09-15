#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
@interface YMKCarparksLayer : NSObject

/**
 * Indicates whether the layer is displayed on a map.
 */
- (BOOL)isVisible;

/**
 * Display or hide the layer on a map.
 */
- (void)setVisibleWithOn:(BOOL)on;

/**
 * Applies JSON style transformations to the carparks layer. Same as
 * setCarparksStyle(0, style). Set to empty string to clear previous
 * styling. Returns true if the style was successfully parsed; false
 * otherwise. If the return value is false, the current carparks style
 * remains unchanged.
 */
- (BOOL)setCarparksStyleWithStyle:(nonnull NSString *)style;

/**
 * Applies JSON style transformations to the carparks layer. Replaces
 * previous styling with the specified ID (if such exists). Stylings are
 * applied in an ascending order. Set to empty string to clear previous
 * styling with the specified ID. Returns true if the style was
 * successfully parsed; false otherwise. If the return value is false,
 * the current carparks style remains unchanged.
 */
- (BOOL)setCarparksStyleWithId:(NSInteger)id
                         style:(nonnull NSString *)style;

/**
 * Resets all JSON style transformations applied to the carparks layer.
 */
- (void)resetCarparksStyles;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
