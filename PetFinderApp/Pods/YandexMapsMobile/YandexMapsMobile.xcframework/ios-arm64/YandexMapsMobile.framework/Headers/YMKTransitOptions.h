#import <YandexMapsMobile/YMKOptions.h>

/**
 * Types which are allowed to be used in filters.
 */
typedef NS_OPTIONS(NSUInteger, YMKFilterVehicleTypes) {
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesNone = 0,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesBus = 1 << 0,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesMinibus = 1 << 1,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesRailway = 1 << 2,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesSuburban = 1 << 3,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesTramway = 1 << 4,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesTrolleybus = 1 << 5,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesUnderground = 1 << 6,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesMetrobus = 1 << 7,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesDolmus = 1 << 8,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesHistoricTram = 1 << 9,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesRapidTram = 1 << 10,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesLightRail = 1 << 11,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesSuburbanExpress = 1 << 12,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesAeroexpress = 1 << 13,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesWater = 1 << 14,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesFerry = 1 << 15,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesFunicular = 1 << 16,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesCable = 1 << 17,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesAero = 1 << 18,
    /**
     * Undocumented
     */
    YMKFilterVehicleTypesSBahn = 1 << 19
};

/**
 * User-defined options, like time options and filter options.
 */
@interface YMKTransitOptions : NSObject

/**
 * Transport types that the router will avoid. The value should be one
 * of YMKFilterVehicleTypes, or their bitwise 'OR' combination.
 */
@property (nonatomic, readonly) YMKFilterVehicleTypes avoid;

/**
 * Desired departure/arrival time settings. Empty YMKTimeOptions for
 * requests that are not time-dependent.
 */
@property (nonatomic, readonly, nonnull) YMKTimeOptions *timeOptions;


+ (nonnull YMKTransitOptions *)transitOptionsWithAvoid:( YMKFilterVehicleTypes)avoid
                                           timeOptions:(nonnull YMKTimeOptions *)timeOptions;


- (nonnull YMKTransitOptions *)init;

@end
