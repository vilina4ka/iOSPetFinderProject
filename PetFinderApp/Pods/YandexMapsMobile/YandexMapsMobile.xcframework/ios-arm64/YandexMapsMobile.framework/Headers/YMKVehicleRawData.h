#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKMasstransitCommon.h>

/**
 * Represents a mass transport unit on the map
 */
@interface YMKVehicleRawData : NSObject<YMKBaseMetadata>

/**
 * Id of a vehicle
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Id of the line thread on which the vehicle is running
 */
@property (nonatomic, readonly, nonnull) NSString *threadId;

/**
 * Stores the vehicle's public transport line info
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitLine *line;


+ (nonnull YMKVehicleRawData *)vehicleRawDataWithId:(nonnull NSString *)id
                                           threadId:(nonnull NSString *)threadId
                                               line:(nonnull YMKMasstransitLine *)line;


@end
