#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKLocationManager.h>

@class YMKSimulationSettings;

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKSimulationAccuracy) {
    /**
     * Generate locations strictly the geometry
     */
    YMKSimulationAccuracyFine,
    /**
     * Generate locations with normal distribution
     */
    YMKSimulationAccuracyCoarse
};

/**
 * Listens for updates for location simulation.
 */
@protocol YMKLocationSimulatorListener <NSObject>

/**
 * Simulation is finished.
 */
- (void)onSimulationFinished;

@end

/**
 * Undocumented
 */
@interface YMKRange : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) double from;

/**
 * Undocumented
 */
@property (nonatomic, readonly) double to;


+ (nonnull YMKRange *)rangeWithFrom:( double)from
                                 to:( double)to;


@end

/**
 * Undocumented
 */
@interface YMKTimeInterval : NSObject

/**
 * Lower limit in milliseconds.
 */
@property (nonatomic, readonly) NSTimeInterval from;

/**
 * Upper limit in milliseconds.
 */
@property (nonatomic, readonly) NSTimeInterval to;


+ (nonnull YMKTimeInterval *)timeIntervalWithFrom:( NSTimeInterval)from
                                               to:( NSTimeInterval)to;


@end

/**
 * Undocumented
 */
@interface YMKLocationError : NSObject

/**
 * The error of spreading locations across the route.
 */
@property (nonatomic, readonly, nonnull) YMKRange *lateralErrorRange;

/**
 * The error of spreading locations along the route.
 */
@property (nonatomic, readonly, nonnull) YMKRange *longitudinalErrorRange;


+ (nonnull YMKLocationError *)locationErrorWithLateralErrorRange:(nonnull YMKRange *)lateralErrorRange
                                          longitudinalErrorRange:(nonnull YMKRange *)longitudinalErrorRange;


@end

/**
 * Undocumented
 */
@interface YMKLocationSettings : NSObject

/**
 * Flag whether to provide accuracy value.
 */
@property (nonatomic, readonly) BOOL provideAccuracy;

/**
 * Location accuracy range in meters.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKRange *accuracy;

/**
 * Location time interval in milliseconds.
 */
@property (nonatomic, readonly, nonnull) YMKTimeInterval *locationTimeInterval;

/**
 * Flag whether to provide speed value.
 */
@property (nonatomic, readonly) BOOL provideSpeed;

/**
 * The speed in meters per second.
 */
@property (nonatomic, readonly) double speed;

/**
 * Flag whether to provide error of heading.
 */
@property (nonatomic, readonly) BOOL provideHeading;

/**
 * The current heading error range in degrees relative to true heading,
 * clockwise.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKRange *headingError;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKLocationError *locationError;

/**
 * Flag whether to provide wheel speed value.
 */
@property (nonatomic, readonly) BOOL provideWheelSpeed;

/**
 * Time interval of getting the wheel speed in milliseconds. After
 * publication the wheel speed corresponds to the speed value.
 */
@property (nonatomic, readonly, nonnull) YMKTimeInterval *wheelSpeedTimeInterval;


+ (nonnull YMKLocationSettings *)locationSettingsWithProvideAccuracy:( BOOL)provideAccuracy
                                                            accuracy:(nullable YMKRange *)accuracy
                                                locationTimeInterval:(nonnull YMKTimeInterval *)locationTimeInterval
                                                        provideSpeed:( BOOL)provideSpeed
                                                               speed:( double)speed
                                                      provideHeading:( BOOL)provideHeading
                                                        headingError:(nullable YMKRange *)headingError
                                                       locationError:(nonnull YMKLocationError *)locationError
                                                   provideWheelSpeed:( BOOL)provideWheelSpeed
                                              wheelSpeedTimeInterval:(nonnull YMKTimeInterval *)wheelSpeedTimeInterval;


@end

/**
 * Undocumented
 */
@interface YMKSimulationSettings : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKPolyline *geometry;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKLocationSettings *locationSettings;


+ (nonnull YMKSimulationSettings *)simulationSettingsWithGeometry:(nonnull YMKPolyline *)geometry
                                                 locationSettings:(nonnull YMKLocationSettings *)locationSettings;


@end

/**
 * Simulates the device location.
 */
@interface YMKLocationSimulator : YMKLocationManager
/**
 * The polyline describing the location.
 *
 * Optional property, can be nil.
 */
@property (nonatomic, nullable) YMKPolyline *geometry __attribute__((deprecated("Now field in SimulationSettings settings.")));
/**
 * Movement speed.
 */
@property (nonatomic) double speed __attribute__((deprecated("Now field in settings.")));
/**
 * Undocumented
 */
@property (nonatomic, nonnull) NSArray<YMKSimulationSettings *> *settings;

/**
 * Subscribes to simulation events.
 *
 * The class does not retain the object in the 'simulatorListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)subscribeForSimulatorEventsWithSimulatorListener:(nonnull id<YMKLocationSimulatorListener>)simulatorListener;

/**
 * Unsubscribes from simulation events.
 *
 * The class does not retain the object in the 'simulatorListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)unsubscribeFromSimulatorEventsWithSimulatorListener:(nonnull id<YMKLocationSimulatorListener>)simulatorListener;

/**
 * Start simulation.
 *
 * @param simulationAccuracy Generate locations with given accuracy.
 */
- (void)startSimulationWithSimulationAccuracy:(YMKSimulationAccuracy)simulationAccuracy;

/**
 * Stop simulation.
 */
- (void)stopSimulation;

/**
 * The position of the polyline.
 */
- (nonnull YMKPolylinePosition *)polylinePosition;
/**
 * True if simulator is not suspended.
 */
@property (nonatomic, readonly, getter=isActive) BOOL active;

/**
 * Fill location::Location::speed.
 */
- (void)setLocationSpeedProvidingWithProvide:(BOOL)provide __attribute__((deprecated("Use simulatorSettings.locationSettings.speed.enabled.")));

@end
