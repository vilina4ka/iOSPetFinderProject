#import <Foundation/Foundation.h>

@class YMKTextStyle;

/**
 * Provides an interface to set text and its style for a placemark.
 */
@interface YMKPlacemarkText : NSObject
/**
 * UTF-8 encoded text to be displayed with the PlacemarkMapObject Empty
 * string means no text
 */
@property (nonatomic, nonnull) NSString *text;
/**
 * The style properties (size, color, etc.) of the placemark text. Note:
 * The current style cannot be modified directly - you must reset it to
 * apply changes.
 */
@property (nonatomic, nonnull) YMKTextStyle *style;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
