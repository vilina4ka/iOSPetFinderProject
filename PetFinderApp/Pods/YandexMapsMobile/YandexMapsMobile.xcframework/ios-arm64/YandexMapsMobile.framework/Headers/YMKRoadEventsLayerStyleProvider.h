#import <YandexMapsMobile/YMKRoadEventsEventTag.h>
#import <YandexMapsMobile/YMKSignificance.h>

#import <UIKit/UIKit.h>

@class YMKRoadEventsLayerRoadEventStyle;
@class YMKRoadEventsLayerRoadEventStylingProperties;
@class YMKRoadEventsLayerTextStyle;

/**
 * Undocumented
 */
@protocol YMKRoadEventsLayerStyleProvider <NSObject>

/**
 * Provide style for given road event. Must produce same style for same
 * input arguments.
 *
 * @param scaleFactor Scale factor of a map window displaying this road
 * event. Road event icon image scale factor must match this value.
 *
 * @return `false` if road event must not be displayed at all.
 */
- (BOOL)provideStyleWithRoadEventStylingProperties:(nonnull YMKRoadEventsLayerRoadEventStylingProperties *)roadEventStylingProperties
                                       isNightMode:(BOOL)isNightMode
                                       scaleFactor:(float)scaleFactor
                                             style:(nonnull YMKRoadEventsLayerRoadEventStyle *)style;

@end

/**
 * Undocumented
 */
@interface YMKRoadEventsLayerTextStyle : NSObject

/**
 * Font size in device-independent pixels.
 */
@property (nonatomic, readonly) float fontSize;

/**
 * Text primary color.
 */
@property (nonatomic, readonly, nonnull) UIColor *color;

/**
 * Text outline color.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) UIColor *outlineColor;


+ (nonnull YMKRoadEventsLayerTextStyle *)textStyleWithFontSize:( float)fontSize
                                                         color:(nonnull UIColor *)color
                                                  outlineColor:(nullable UIColor *)outlineColor;


@end

/**
 * Undocumented
 */
@interface YMKRoadEventsLayerRoadEventStyle : NSObject
/**
 * Road event is visible only if current camera zoom is greater or equal
 * than this value.
 */
@property (nonatomic) NSInteger zoomMin;

/**
 * Road event icon image.
 */
- (void)setIconImage:(nonnull UIImage *)image;
/**
 * Icon anchor, (0, 0) is top left and (1.0, 1.0) is bottom right.
 */
@property (nonatomic) CGPoint iconAnchor;
/**
 * Piecewise linear scale function. See Placemark's scale function.
 */
@property (nonatomic, nonnull) NSArray<NSValue *> *zoomScaleFunction;
/**
 * Style of caption displayed under the road event icon.
 *
 * Optional property, can be nil.
 */
@property (nonatomic, nullable) YMKRoadEventsLayerTextStyle *captionStyle;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end

/**
 * Interface that has subset of fields of RoadEvent necessary for
 * providing style.
 */
@interface YMKRoadEventsLayerRoadEventStylingProperties : NSObject
/**
 * Set of road event tags.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSNumber *> *tags;

/**
 * Road events with a high significance can be visible on overview
 * zooms, while events with low significance usually visible on detailed
 * zooms only. Significance of a road event can depend on a road
 * category this event is snapped to, number of comments of this event
 * and other factors. Two road events with same significance but
 * different tag sets can be visible on different zoom ranges.
 */
- (BOOL)hasSignificanceGreaterOrEqualWithSignificance:(YMKRoadEventSignificance)significance;
/**
 * Whether road event will become active in the future. See RoadEvent
 * for details.
 */
@property (nonatomic, readonly, getter=isInFuture) BOOL inFuture;
/**
 * Road event placed on a route. See
 * RoadEventsLayer.setRoadEventsOnRoute.
 */
@property (nonatomic, readonly, getter=isOnRoute) BOOL onRoute;
/**
 * Road event was selected by RoadEventsLayer.selectRoadEvent.
 */
@property (nonatomic, readonly, getter=isSelected) BOOL selected;
/**
 * Currently logged in user is either an author of this road event or
 * has commented it.
 */
@property (nonatomic, readonly, getter=isUserEvent) BOOL userEvent;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
