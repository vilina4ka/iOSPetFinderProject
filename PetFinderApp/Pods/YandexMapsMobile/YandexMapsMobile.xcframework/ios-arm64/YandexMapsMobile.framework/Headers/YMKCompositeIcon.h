#import <YandexMapsMobile/YMKCallback.h>
#import <YandexMapsMobile/YMKPlacemarkPresentation.h>

#import <UIKit/UIKit.h>

@class YMKIcon;
@class YMKIconStyle;

/**
 * Combines multiple icons into one.
 */
@interface YMKCompositeIcon : YMKPlacemarkPresentation

/**
 * Creates or resets a named layer with an icon and its style.
 */
- (void)setIconWithName:(nonnull NSString *)name
                  image:(nonnull UIImage *)image
                  style:(nonnull YMKIconStyle *)style;

/**
 * Creates or resets a named layer that contains an icon and its style.
 *
 * @param onFinished Called when an icon is loaded.
 */
- (void)setIconWithName:(nonnull NSString *)name
                  image:(nonnull UIImage *)image
                  style:(nonnull YMKIconStyle *)style
               callback:(nonnull YMKCallback)callback;

/**
 * Changes the icon style for a specific layer.
 */
- (void)setIconStyleWithName:(nonnull NSString *)name
                       style:(nonnull YMKIconStyle *)style;

/**
 * Returns named Icon object that can be used to set icon and its style.
 * Creates an empty Icon if it didn't exist.
 */
- (nonnull YMKIcon *)iconWithName:(nonnull NSString *)name;

/**
 * Removes the named layer.
 */
- (void)removeIconWithName:(nonnull NSString *)name;

/**
 * Removes all layers.
 */
- (void)removeAll;

@end
