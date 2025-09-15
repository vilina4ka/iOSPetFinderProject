#import <YandexMapsMobile/YMKCallback.h>
#import <YandexMapsMobile/YMKPlacemarkPresentation.h>
#import <YandexMapsMobile/YRTViewProvider.h>

@class YMKIconStyle;

/**
 * Provides an interface to set view and its style for a placemark.
 */
@interface YMKPlacemarkView : YMKPlacemarkPresentation

/**
 * Sets the view with the given style for the placemark.
 */
- (void)setViewWithImage:(nonnull YRTViewProvider *)image
                   style:(nonnull YMKIconStyle *)style;

/**
 * Sets the view with the given style for the placemark. The callback
 * will be called immediately after the view finished loading.
 *
 * @param onFinished Called when the view is loaded.
 */
- (void)setViewWithImage:(nonnull YRTViewProvider *)image
                   style:(nonnull YMKIconStyle *)style
                callback:(nonnull YMKCallback)callback;
/**
 * The style properties (scale, zIndex, etc.) of the view placemark.
 * Note: The current style cannot be modified directly - you must reset
 * it to apply changes.
 */
@property (nonatomic, nonnull) YMKIconStyle *style;

@end
