#import <YandexMapsMobile/YMKScreenTypes.h>
#import <YandexMapsMobile/YRTViewProvider.h>

#import <UIKit/UIKit.h>

/**
 * Allows to render overlay on the screen.
 */
@interface YMKOverlay : NSObject

/**
 * Sets image as content of overlay, resets view. Window origin (0, 0) -
 * top left corner.
 */
- (void)setImageWithImage:(nonnull UIImage *)image
                     rect:(nonnull YMKScreenRect *)rect;

/**
 * Sets view as content of overlay, resets image. Window origin (0, 0) -
 * top left corner.
 */
- (void)setViewWithView:(nonnull YRTViewProvider *)view
                   rect:(nonnull YMKScreenRect *)rect;

/**
 * Removes the overlay from the map.
 */
- (void)remove;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
