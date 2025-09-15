#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKRoadEventsEventTag.h>

/**
 * Undocumented
 */
@interface YMKRoadEventsLayerRoadEvent : NSObject

/**
 * The road event unique id.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Position of the road event on the globe.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *position;

/**
 * Set of road event tags.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSNumber *> *tags;

/**
 * Text caption displayed under the road event icon.
 */
@property (nonatomic, readonly, nonnull) NSString *caption;

/**
 * Some road events can be not active yet, but still must be displayed
 * to notify users about future events, for example drawbridges or
 * closures. Usually such events have a greyscale icon and/or clock
 * drawn in the icon's corner.
 */
@property (nonatomic, readonly) BOOL isInFuture;


+ (nonnull YMKRoadEventsLayerRoadEvent *)roadEventsLayerRoadEventWithId:(nonnull NSString *)id
                                                               position:(nonnull YMKPoint *)position
                                                                   tags:(nonnull NSArray<NSNumber *> *)tags
                                                                caption:(nonnull NSString *)caption
                                                             isInFuture:( BOOL)isInFuture;


@end
