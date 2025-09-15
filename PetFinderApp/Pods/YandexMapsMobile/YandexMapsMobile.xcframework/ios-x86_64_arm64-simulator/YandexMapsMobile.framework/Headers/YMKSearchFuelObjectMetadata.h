#import <YandexMapsMobile/YMKAttribution.h>
#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKTaxiMoney.h>

/**
 * Fuel name and price.
 */
@interface YMKSearchFuelType : NSObject

/**
 * Fuel name.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *name;

/**
 * Fuel price.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKTaxiMoney *price;


+ (nonnull YMKSearchFuelType *)fuelTypeWithName:(nullable NSString *)name
                                          price:(nullable YMKTaxiMoney *)price;


@end

/**
 * Fuel snippet.
 */
@interface YMKSearchFuelMetadata : NSObject<YMKBaseMetadata>

/**
 * Snippet update time as UNIX timestamp.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *timestamp;

/**
 * Fuel list.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchFuelType *> *fuels;

/**
 * Attribution information.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKAttribution *attribution;


+ (nonnull YMKSearchFuelMetadata *)fuelMetadataWithTimestamp:(nullable NSNumber *)timestamp
                                                       fuels:(nonnull NSArray<YMKSearchFuelType *> *)fuels
                                                 attribution:(nullable YMKAttribution *)attribution;


@end
