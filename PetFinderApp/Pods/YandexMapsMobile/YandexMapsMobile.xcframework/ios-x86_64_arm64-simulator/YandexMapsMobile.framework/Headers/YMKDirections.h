#import <YandexMapsMobile/YMKCarparksLayer.h>
#import <YandexMapsMobile/YMKDrivingRouter.h>
#import <YandexMapsMobile/YMKMapWindow.h>

@class YMKDirections;

/**
 * Undocumented
 */
@interface YMKDirections : NSObject

/**
 * Creates the carparks layer.
 */
- (nonnull YMKCarparksLayer *)createCarparksLayerWithMapWindow:(nonnull YMKMapWindow *)mapWindow;

/**
 * Creates a manager that builds driving routes.
 */
- (nonnull YMKDrivingRouter *)createDrivingRouterWithType:(YMKDrivingRouterType)type NS_SWIFT_NAME(createDrivingRouter(withType:));

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
 * Undocumented
 */
@interface YMKDirectionsFactory : NSObject

+ (nonnull YMKDirections *)instance;

@end
