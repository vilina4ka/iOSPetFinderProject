#import <Foundation/Foundation.h>

@class YMKSearchAddressComponent;

/**
 * Contains structured address, formatted address, postal code and
 * country code.
 *
 * Structured address is an ordered list of components (usually
 * administrative hierarchy). Formatted address is a full address as a
 * single string. Formatted address generally can't be obtained from
 * component names. Some components could be ignored (large
 * administrative region) or absent (office number).
 */
@interface YMKSearchAddress : NSObject

/**
 * Human-readable address.
 */
@property (nonatomic, readonly, nonnull) NSString *formattedAddress;

/**
 * Additional address info.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *additionalInfo;

/**
 * Postal/Zip code.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *postalCode;

/**
 * Country code in ISO 3166-1 alpha-2 format (two-letter country code).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *countryCode;

/**
 * Address component list, see YMKSearchAddressComponent, may be empty.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchAddressComponent *> *components;


+ (nonnull YMKSearchAddress *)addressWithFormattedAddress:(nonnull NSString *)formattedAddress
                                           additionalInfo:(nullable NSString *)additionalInfo
                                               postalCode:(nullable NSString *)postalCode
                                              countryCode:(nullable NSString *)countryCode
                                               components:(nonnull NSArray<YMKSearchAddressComponent *> *)components;


@end

/**
 * An address component kind, for example, large administrative area.
 */
typedef NS_ENUM(NSUInteger, YMKSearchComponentKind) {
    /**
     * Unknown component kind
     */
    YMKSearchComponentKindUnknown,
    /**
     * Country component.
     */
    YMKSearchComponentKindCountry,
    /**
     * Region component.
     */
    YMKSearchComponentKindRegion,
    /**
     * Province component.
     */
    YMKSearchComponentKindProvince,
    /**
     * Area component.
     */
    YMKSearchComponentKindArea,
    /**
     * Locality component.
     */
    YMKSearchComponentKindLocality,
    /**
     * District component.
     */
    YMKSearchComponentKindDistrict,
    /**
     * Street component.
     */
    YMKSearchComponentKindStreet,
    /**
     * House component.
     */
    YMKSearchComponentKindHouse,
    /**
     * Entrance component.
     */
    YMKSearchComponentKindEntrance,
    /**
     * Indoor level component.
     */
    YMKSearchComponentKindLevel,
    /**
     * Apartment component.
     */
    YMKSearchComponentKindApartment,
    /**
     * Line component.
     */
    YMKSearchComponentKindRoute,
    /**
     * Generic station component.
     */
    YMKSearchComponentKindStation,
    /**
     * Metro station component.
     */
    YMKSearchComponentKindMetroStation,
    /**
     * Railway station component.
     */
    YMKSearchComponentKindRailwayStation,
    /**
     * Vegetation component.
     */
    YMKSearchComponentKindVegetation,
    /**
     * Hydro component.
     */
    YMKSearchComponentKindHydro,
    /**
     * Airport component.
     */
    YMKSearchComponentKindAirport,
    /**
     * Kind for other toponyms, for example cemeteries or some other
     * landmarks, which can't be easily described by kinds.
     */
    YMKSearchComponentKindOther
};

/**
 * Single address component.
 *
 * Component represents a single entry in the administrative hierarchy
 * of the address.
 */
@interface YMKSearchAddressComponent : NSObject

/**
 * Component name.
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * Component kinds. May contain both general and specific kind, for
 * example YMKSearchComponentKindStation and
 * YMKSearchComponentKindMetroStation.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSNumber *> *kinds;


+ (nonnull YMKSearchAddressComponent *)componentWithName:(nonnull NSString *)name
                                                   kinds:(nonnull NSArray<NSNumber *> *)kinds;


@end
