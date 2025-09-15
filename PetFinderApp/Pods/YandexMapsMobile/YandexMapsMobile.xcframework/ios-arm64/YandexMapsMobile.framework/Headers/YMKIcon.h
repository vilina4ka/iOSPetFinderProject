#import <YandexMapsMobile/YMKCallback.h>
#import <YandexMapsMobile/YMKPlacemarkPresentation.h>

#import <UIKit/UIKit.h>

@class YMKIconStyle;

/**
 * Provides an interface to set icon and its style for a placemark.
 */
@interface YMKIcon : YMKPlacemarkPresentation

/**
 * Sets the image with the given style for the icon.
 */
- (void)setImageWithImage:(nonnull UIImage *)image
                    style:(nonnull YMKIconStyle *)style;

/**
 * Sets the image with the given style for the icon. The callback will
 * be called immediately after the icon finished loading.
 *
 * @param onFinished Called when the icon is loaded.
 */
- (void)setImageWithImage:(nonnull UIImage *)image
                    style:(nonnull YMKIconStyle *)style
                 callback:(nonnull YMKCallback)callback;
/**
 * The style properties (scale, zIndex, etc.) of the icon placemark.
 * Note: The current style cannot be modified directly - you must reset
 * it to apply changes.
 */
@property (nonatomic, nonnull) YMKIconStyle *style;

@end
