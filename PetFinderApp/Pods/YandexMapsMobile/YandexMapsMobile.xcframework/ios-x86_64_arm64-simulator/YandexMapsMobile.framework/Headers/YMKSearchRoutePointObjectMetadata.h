#import <YandexMapsMobile/YMKDirection.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKTaxiMoney.h>

/**
 * An entrance to a building
 */
@interface YMKSearchEntrance : NSObject

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *name;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKPoint *point;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKDirection *direction;


+ (nonnull YMKSearchEntrance *)entranceWithName:(nullable NSString *)name
                                          point:(nonnull YMKPoint *)point
                                      direction:(nullable YMKDirection *)direction;


@end

/**
 * Undocumented
 */
@interface YMKSearchParkingAttributes : NSObject

/**
 * Parking organization URI. For example, parking zone or any toll area
 * or inside building parking.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *orgURI;

/**
 * Price of the first hour.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKTaxiMoney *firstHourPrice;

/**
 * Maximum number of parking places (capacity).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *placesCount;


+ (nonnull YMKSearchParkingAttributes *)parkingAttributesWithOrgURI:(nullable NSString *)orgURI
                                                     firstHourPrice:(nullable YMKTaxiMoney *)firstHourPrice
                                                        placesCount:(nullable NSNumber *)placesCount;


@end
