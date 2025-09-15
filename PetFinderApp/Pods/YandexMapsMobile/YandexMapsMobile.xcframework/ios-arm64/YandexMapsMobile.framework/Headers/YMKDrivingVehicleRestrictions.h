#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Undocumented
 */
@interface YMKDrivingVehicleRestriction : NSObject

/**
 * Actual weight limit, tons. See Driving Rules sign 3.11.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *weightLimit;

/**
 * Axle load weight limit, tons. See Driving Rules sign 3.12.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *axleWeightLimit;

/**
 * Maximal allowed weight limit, tons. See Driving Rules sign 3.4, table
 * 8.11.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *maxWeightLimit;

/**
 * Height limit, meters. See Driving Rules sign 3.13.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *heightLimit;

/**
 * Width limit, meters. See Driving Rules sign 3.14.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *widthLimit;

/**
 * Length limit, meters. See Driving Rules sign 3.15.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *lengthLimit;

/**
 * Payload limit, tons.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *payloadLimit;

/**
 * Minimal allowed engine ecological class. See Driving Rules sign 5.35
 * and 5.36.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *minEcoClass;

/**
 * Trailer is not allowed. See Driving Rules sign 3.7.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *trailerNotAllowed;

/**
 * Legal or physical limitation.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *legal;


+ (nonnull YMKDrivingVehicleRestriction *)vehicleRestrictionWithWeightLimit:(nullable NSNumber *)weightLimit
                                                            axleWeightLimit:(nullable NSNumber *)axleWeightLimit
                                                             maxWeightLimit:(nullable NSNumber *)maxWeightLimit
                                                                heightLimit:(nullable NSNumber *)heightLimit
                                                                 widthLimit:(nullable NSNumber *)widthLimit
                                                                lengthLimit:(nullable NSNumber *)lengthLimit
                                                               payloadLimit:(nullable NSNumber *)payloadLimit
                                                                minEcoClass:(nullable NSNumber *)minEcoClass
                                                          trailerNotAllowed:(nullable NSNumber *)trailerNotAllowed
                                                                      legal:(nullable NSNumber *)legal;


@end

/**
 * Undocumented
 */
@interface YMKDrivingRoadVehicleRestriction : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKDrivingVehicleRestriction *vehicleRestriction;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *position;


+ (nonnull YMKDrivingRoadVehicleRestriction *)roadVehicleRestrictionWithVehicleRestriction:(nonnull YMKDrivingVehicleRestriction *)vehicleRestriction
                                                                                  position:(nonnull YMKSubpolyline *)position;


@end

/**
 * Undocumented
 */
@interface YMKDrivingManoeuvreVehicleRestriction : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKDrivingVehicleRestriction *vehicleRestriction;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKDrivingManoeuvreVehicleRestriction *)manoeuvreVehicleRestrictionWithVehicleRestriction:(nonnull YMKDrivingVehicleRestriction *)vehicleRestriction
                                                                                            position:(nonnull YMKPolylinePosition *)position;


@end
