#import <YandexMapsMobile/YMKCallback.h>
#import <YandexMapsMobile/YMKMapObject.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YRTViewProvider.h>

#import <UIKit/UIKit.h>

@class YMKCompositeIcon;
@class YMKIcon;
@class YMKIconStyle;
@class YMKModel;
@class YMKPlacemarkAnimation;
@class YMKPlacemarkText;
@class YMKPlacemarkView;
@class YMKTextStyle;

/**
 * Represents a geo-positioned object on the map.
 */
@interface YMKPlacemarkMapObject : YMKMapObject
/**
 * Undocumented
 */
@property (nonatomic, nonnull) YMKPoint *geometry;
/**
 * Angle between the direction of an object and the direction to north.
 * Measured in degrees. Default: 0.f.
 */
@property (nonatomic) float direction;
/**
 * Opacity multiplicator for the placemark content. Values below 0 will
 * be set to 0. Default: 1.
 */
@property (nonatomic) float opacity;

/**
 * Sets an icon with the default style for the placemark. Switches off
 * and resets model/composite icon/animation/view.
 */
- (void)setIconWithImage:(nonnull UIImage *)image;

/**
 * Sets an icon with the given style for the placemark. Switches off and
 * resets model/composite icon/animation/view.
 */
- (void)setIconWithImage:(nonnull UIImage *)image
                   style:(nonnull YMKIconStyle *)style;

/**
 * Sets an icon with the default style for the placemark. Switches off
 * and resets model/composite icon/animation/view. The callback is
 * called immediately after the image finished loading. This means you
 * can, for example, change the placemark visibility with a new icon.
 *
 * @param onFinished Called when the icon is loaded.
 */
- (void)setIconWithImage:(nonnull UIImage *)image
                callback:(nonnull YMKCallback)callback;

/**
 * Sets an icon with the given style for the placemark. Switches off and
 * resets model/composite icon/animation/view. The callback is called
 * immediately after the image finished loading. This means you can, for
 * example, change the placemark visibility with a new icon.
 *
 * @param onFinished Called when the icon is loaded.
 */
- (void)setIconWithImage:(nonnull UIImage *)image
                   style:(nonnull YMKIconStyle *)style
                callback:(nonnull YMKCallback)callback;

/**
 * Changes the icon style. Valid only for the single icon, the view and
 * the animated icon.
 */
- (void)setIconStyleWithStyle:(nonnull YMKIconStyle *)style;

/**
 * Returns Icon object that can be used to set icon and its style for
 * the placemark. Switches off and resets composite
 * icon/model/animation/view.
 */
- (nonnull YMKIcon *)useIcon;

/**
 * Returns CompositeIcon object that can be used to set icons and their
 * styles for the placemark. Switches off and resets
 * icon/model/animation/view.
 */
- (nonnull YMKCompositeIcon *)useCompositeIcon;

/**
 * Returns Model object that can be used to set model and its style for
 * the placemark. Switches off and resets icon/composite
 * icon/animation/view.
 */
- (nonnull YMKModel *)useModel;

/**
 * Returns PlacemarkAnimation object that can be used to control
 * animation of the placemark. Switches off and resets icon/composite
 * icon/model/view.
 */
- (nonnull YMKPlacemarkAnimation *)useAnimation;

/**
 * Returns PlacemarkView object that can be used to set view and its
 * style for the placemark. Switches off and resets icon/composite
 * icon/model/animation.
 */
- (nonnull YMKPlacemarkView *)useView;
/**
 * PlacemarkText can be used to set text and its style for the
 * placemark. It's optional parameter and can be used in addition to
 * placemark objects
 */
@property (nonatomic, readonly, readonly, nonnull) YMKPlacemarkText *text;

/**
 * Sets the view with the default style for the placemark. Switches off
 * and resets icon/composite icon/animation/model.
 */
- (void)setViewWithView:(nonnull YRTViewProvider *)view;

/**
 * Sets the view with the given style for the placemark. Switches off
 * and resets icon/composite icon/animation/view.
 */
- (void)setViewWithView:(nonnull YRTViewProvider *)view
                  style:(nonnull YMKIconStyle *)style;

/**
 * Sets the view with the default style for the placemark. Switches off
 * and resets icon/composite icon/animation/view. The callback will be
 * called immediately after the view finished loading.
 *
 * @param onFinished Called when the icon is loaded.
 */
- (void)setViewWithView:(nonnull YRTViewProvider *)view
               callback:(nonnull YMKCallback)callback;

/**
 * Sets the view with the given style for the placemark. Switches off
 * and resets icon/composite icon/animation/view. The callback will be
 * called immediately after the view finished loading.
 *
 * @param onFinished Called when the icon is loaded.
 */
- (void)setViewWithView:(nonnull YRTViewProvider *)view
                  style:(nonnull YMKIconStyle *)style
               callback:(nonnull YMKCallback)callback;

/**
 * Sets piecewise linear scale, depending on the zoom. The 'points' must
 * be sorted by x; x coordinates must be unique. If zoom <
 * minZoom(points) or zoom > maxZoom(points), it is set within the
 * defined bounds before applying the function. By default, the scale
 * function is defined by a single point (1, 1). If points is null or
 * points.empty(), it resets the function to the default. If
 * points.size() == 1, the scale is constant and equals point.y.
 */
- (void)setScaleFunctionWithPoints:(nonnull NSArray<NSValue *> *)points;

/**
 * Sets the text for the placemark, current text style is used
 *
 * @param text is a string in UTF-8 encoding
 */
- (void)setTextWithText:(nonnull NSString *)text;

/**
 * Sets the text with the given style for the placemark
 *
 * @param text is a string in UTF-8 encoding
 */
- (void)setTextWithText:(nonnull NSString *)text
                  style:(nonnull YMKTextStyle *)style;

/**
 * Changes the text style.
 */
- (void)setTextStyleWithStyle:(nonnull YMKTextStyle *)style;

@end
