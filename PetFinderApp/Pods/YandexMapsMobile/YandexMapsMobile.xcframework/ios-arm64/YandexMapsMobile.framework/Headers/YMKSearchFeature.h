#import <YandexMapsMobile/YMKImage.h>

@class YMKSearchFeatureBooleanValue;
@class YMKSearchFeatureEnumValue;
@class YMKSearchFeatureVariantValue;

/**
 * Describes some common feature of organizations. Can be of three
 * types:
 *
 * - boolean (like on/off switch, as for free Wi-Fi availability).
 *
 * - enumerated (can have multiple values at once, like cuisine types in
 * a cafe).
 *
 * - text (like enumerated but with any strings instead of predefined
 * values).
 */
@interface YMKSearchFeature : NSObject

/**
 * Machine readable feature identifier.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Feature value (depends on feature type).
 */
@property (nonatomic, readonly, nonnull) YMKSearchFeatureVariantValue *value;

/**
 * Human readable localized representation.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *name;

/**
 * Reference to information source providing given feature (see
 * YMKAttribution)
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *aref;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKImage *iconLight;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKImage *iconDark;


+ (nonnull YMKSearchFeature *)featureWithId:(nonnull NSString *)id
                                      value:(nonnull YMKSearchFeatureVariantValue *)value
                                       name:(nullable NSString *)name
                                       aref:(nullable NSString *)aref
                                  iconLight:(nullable YMKImage *)iconLight
                                   iconDark:(nullable YMKImage *)iconDark;


@end

/**
 * Value for enumerated features.
 */
@interface YMKSearchFeatureEnumValue : NSObject

/**
 * Machine readable value identifier.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Human readable localized representation.
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * urlTemplate for the image. Available sizes are listed here:
 * http://api.yandex.ru/fotki/doc/format-ref/f-img.xml
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *imageUrlTemplate;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *tags;


+ (nonnull YMKSearchFeatureEnumValue *)enumValueWithId:(nonnull NSString *)id
                                                  name:(nonnull NSString *)name
                                      imageUrlTemplate:(nullable NSString *)imageUrlTemplate
                                                  tags:(nonnull NSArray<NSString *> *)tags;


@end

/**
 * Undocumented
 */
@interface YMKSearchFeatureBooleanValue : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL value;


+ (nonnull YMKSearchFeatureBooleanValue *)booleanValueWithValue:( BOOL)value;


@end

/**
 * A variant combining possible feature values.
 */
@interface YMKSearchFeatureVariantValue : NSObject

@property (nonatomic, readonly, nullable) YMKSearchFeatureBooleanValue *booleanValue;

@property (nonatomic, readonly, nullable) NSArray<NSString *> *textValue;

@property (nonatomic, readonly, nullable) NSArray<YMKSearchFeatureEnumValue *> *enumValue;

+ (nonnull YMKSearchFeatureVariantValue *)variantValueWithBooleanValue:(nonnull YMKSearchFeatureBooleanValue *)booleanValue;

+ (nonnull YMKSearchFeatureVariantValue *)variantValueWithTextValue:(nonnull NSArray<NSString *> *)textValue;

+ (nonnull YMKSearchFeatureVariantValue *)variantValueWithEnumValue:(nonnull NSArray<YMKSearchFeatureEnumValue *> *)enumValue;

@end


/**
 * Collection of features.
 */
@interface YMKSearchFeatureSet : NSObject

/**
 * IDs for features in the collection.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *ids;


+ (nonnull YMKSearchFeatureSet *)featureSetWithIds:(nonnull NSArray<NSString *> *)ids;


@end

/**
 * Group of features.
 */
@interface YMKSearchFeatureGroup : NSObject

/**
 * Group name.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *name;

/**
 * IDs for features in the group.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *ids;


+ (nonnull YMKSearchFeatureGroup *)featureGroupWithName:(nullable NSString *)name
                                                    ids:(nonnull NSArray<NSString *> *)ids;


@end
