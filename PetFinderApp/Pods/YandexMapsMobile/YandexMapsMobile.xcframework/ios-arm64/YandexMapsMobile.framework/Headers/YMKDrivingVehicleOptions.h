#import <YandexMapsMobile/YMKDrivingVehicleType.h>

/**
 * Undocumented
 */
@interface YMKDrivingVehicleOptions : NSObject

/**
 * Sets the vehicle type for special routing.
 */
@property (nonatomic, assign) YMKDrivingVehicleType vehicleType;

/**
 * Real vehicle weight.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *weight;

/**
 * Maximal weight supported by a vehicle axle.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *axleWeight;

/**
 * Maximal allowed weight for the vehicle.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *maxWeight;

/**
 * Vehicle height.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *height;

/**
 * Vehicle width.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *width;

/**
 * Vehicle length.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *length;

/**
 * Vehicle cargo weight.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *payload;

/**
 * Vehicle eco class.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *ecoClass;

/**
 * The vehicle has a trailer attached.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *hasTrailer;

/**
 * The vehicle is permitted for busway.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSNumber *buswayPermitted;

+ (nonnull YMKDrivingVehicleOptions *)vehicleOptionsWithVehicleType:( YMKDrivingVehicleType)vehicleType
                                                             weight:(nullable NSNumber *)weight
                                                         axleWeight:(nullable NSNumber *)axleWeight
                                                          maxWeight:(nullable NSNumber *)maxWeight
                                                             height:(nullable NSNumber *)height
                                                              width:(nullable NSNumber *)width
                                                             length:(nullable NSNumber *)length
                                                            payload:(nullable NSNumber *)payload
                                                           ecoClass:(nullable NSNumber *)ecoClass
                                                         hasTrailer:(nullable NSNumber *)hasTrailer
                                                    buswayPermitted:(nullable NSNumber *)buswayPermitted;


- (nonnull YMKDrivingVehicleOptions *)init;

@end
