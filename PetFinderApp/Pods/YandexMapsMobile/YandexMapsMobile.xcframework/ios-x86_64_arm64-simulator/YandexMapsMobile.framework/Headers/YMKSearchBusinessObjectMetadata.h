#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKLocalizedValue.h>
#import <YandexMapsMobile/YMKSearchAddress.h>
#import <YandexMapsMobile/YMKSearchCategory.h>
#import <YandexMapsMobile/YMKSearchChain.h>
#import <YandexMapsMobile/YMKSearchFeature.h>
#import <YandexMapsMobile/YMKSearchLink.h>
#import <YandexMapsMobile/YMKSearchPhone.h>
#import <YandexMapsMobile/YMKSearchPrecision.h>
#import <YandexMapsMobile/YMKSearchWorkingHours.h>

@class YMKSearchPropertiesItem;

/**
 * Company working status.
 */
typedef NS_ENUM(NSUInteger, YMKSearchClosed) {
    /**
     * Default value.
     */
    YMKSearchClosedUnknown,
    /**
     * A company which is closed forever.
     */
    YMKSearchClosedPermanent,
    /**
     * A company that is closed temporarily.
     */
    YMKSearchClosedTemporary
};

/**
 * Generic key-value property storage.
 */
@interface YMKSearchProperties : NSObject

/**
 * Property list.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchPropertiesItem *> *items;


+ (nonnull YMKSearchProperties *)propertiesWithItems:(nonnull NSArray<YMKSearchPropertiesItem *> *)items;


@end

/**
 * Single property item.
 */
@interface YMKSearchPropertiesItem : NSObject

/**
 * Item key.
 */
@property (nonatomic, readonly, nonnull) NSString *key;

/**
 * Item value.
 */
@property (nonatomic, readonly, nonnull) NSString *value;


+ (nonnull YMKSearchPropertiesItem *)itemWithKey:(nonnull NSString *)key
                                           value:(nonnull NSString *)value;


@end

/**
 * Extended information about company.
 */
@interface YMKSearchBusinessObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * Permanent company id.
 */
@property (nonatomic, readonly, nonnull) NSString *oid;

/**
 * Company name.
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * Company address.
 */
@property (nonatomic, readonly, nonnull) YMKSearchAddress *address;

/**
 * List of categories associated with the company.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchCategory *> *categories;

/**
 * List of phone numbers for the company.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchPhone *> *phones;

/**
 * Open hours for the company.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKSearchWorkingHours *workingHours;

/**
 * Address precision for the company.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *precision;

/**
 * List of features for the company.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchFeature *> *features;

/**
 * Collection of features that probably are of utmost interest to the
 * user.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKSearchFeatureSet *importantFeatures;

/**
 * List of links for the company.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchLink *> *links;

/**
 * Optional distance to the company from geometry provided in request.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKLocalizedValue *distance;

/**
 * List of chains associated with the company.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchChain *> *chains;

/**
 * Company status, present if it is closed.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *closed;

/**
 * If true, company information is not reliable.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *unreliable;

/**
 * Technical field for SEO (transliterated and simplified company name).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *seoname;

/**
 * Short company name.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *shortName;

/**
 * Additional company properties.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKSearchProperties *properties;

/**
 * List of feature groups for the company.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchFeatureGroup *> *featureGroups;

/**
 * Indoor level id (obsolete).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *indoorLevel;


+ (nonnull YMKSearchBusinessObjectMetadata *)businessObjectMetadataWithOid:(nonnull NSString *)oid
                                                                      name:(nonnull NSString *)name
                                                                   address:(nonnull YMKSearchAddress *)address
                                                                categories:(nonnull NSArray<YMKSearchCategory *> *)categories
                                                                    phones:(nonnull NSArray<YMKSearchPhone *> *)phones
                                                              workingHours:(nullable YMKSearchWorkingHours *)workingHours
                                                                 precision:(nullable NSNumber *)precision
                                                                  features:(nonnull NSArray<YMKSearchFeature *> *)features
                                                         importantFeatures:(nullable YMKSearchFeatureSet *)importantFeatures
                                                                     links:(nonnull NSArray<YMKSearchLink *> *)links
                                                                  distance:(nullable YMKLocalizedValue *)distance
                                                                    chains:(nonnull NSArray<YMKSearchChain *> *)chains
                                                                    closed:(nullable NSNumber *)closed
                                                                unreliable:(nullable NSNumber *)unreliable
                                                                   seoname:(nullable NSString *)seoname
                                                                 shortName:(nullable NSString *)shortName
                                                                properties:(nullable YMKSearchProperties *)properties
                                                             featureGroups:(nonnull NSArray<YMKSearchFeatureGroup *> *)featureGroups
                                                               indoorLevel:(nullable NSString *)indoorLevel;


@end
