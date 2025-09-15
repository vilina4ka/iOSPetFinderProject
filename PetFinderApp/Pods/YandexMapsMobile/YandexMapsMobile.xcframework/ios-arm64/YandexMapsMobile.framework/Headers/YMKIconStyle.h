#import <YandexMapsMobile/YMKRect.h>
#import <YandexMapsMobile/YMKRotationType.h>

#import <UIKit/UIKit.h>

/**
 * The style of created icons.
 */
@interface YMKIconStyle : NSObject

/**
 * An anchor is used to alter image placement. Normalized: (0.0f, 0.0f)
 * denotes the top left image corner; (1.0f, 1.0f) denotes bottom right.
 * Default is (0.5f, 0.5f).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSValue *anchor;

/**
 * Icon rotation type. Default: NoRotation.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *rotationType;

/**
 * Z-index of the icon, relative to the placemark's z-index.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *zIndex;

/**
 * If true, the icon is displayed on the map surface. If false, the icon
 * is displayed on the screen surface. Default: false.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *flat;

/**
 * Sets icon visibility. Default: true.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *visible;

/**
 * Scale of the icon. Default: 1.0f.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *scale;

/**
 * Tappable area on the icon. Coordinates are measured the same way as
 * anchor coordinates. If rect is empty or invalid, the icon will not
 * process taps. By default, icons process all taps.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, strong, nullable) YMKRect *tappableArea;

+ (nonnull YMKIconStyle *)iconStyleWithAnchor:(nullable NSValue *)anchor
                                 rotationType:(nullable NSNumber *)rotationType
                                       zIndex:(nullable NSNumber *)zIndex
                                         flat:(nullable NSNumber *)flat
                                      visible:(nullable NSNumber *)visible
                                        scale:(nullable NSNumber *)scale
                                 tappableArea:(nullable YMKRect *)tappableArea;


@end
