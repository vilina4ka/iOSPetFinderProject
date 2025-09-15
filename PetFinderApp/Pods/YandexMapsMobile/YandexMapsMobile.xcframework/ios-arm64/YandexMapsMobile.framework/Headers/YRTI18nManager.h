#import <YandexMapsMobile/YRTPrefs.h>

@class YRTCanonicalUnit;
@class YRTI18nManager;

/**
 * Represents a unit with the value and measurement separated.
 */
@interface YRTCanonicalUnit : NSObject

/**
 * The unit of measurement.
 */
@property (nonatomic, readonly, nonnull) NSString *unit;

/**
 * The numerical value.
 */
@property (nonatomic, readonly) double value;


+ (nonnull YRTCanonicalUnit *)canonicalUnitWithUnit:(nonnull NSString *)unit
                                              value:( double)value;


@end

/**
 * Localization manager.
 */
@interface YRTI18nManager : NSObject

/**
 * Converts a distance value to the current locale.
 */
- (nonnull NSString *)localizeDistanceWithDistance:(NSInteger)distance;

/**
 * Converts a duration to the current locale.
 */
- (nonnull NSString *)localizeDurationWithDuration:(NSInteger)duration;

/**
 * Converts speed to the current locale.
 */
- (nonnull NSString *)localizeSpeedWithSpeed:(double)speed;

/**
 * Converts data size to the current locale.
 */
- (nonnull NSString *)localizeDataSizeWithDataSize:(long long)dataSize;

/**
 * Represents the speed with the value and unit of measurement
 * separated.
 */
- (nonnull YRTCanonicalUnit *)canonicalSpeedWithSpeed:(double)speed;

/**
 * Localizes a value represented by canonical units.
 */
- (nonnull NSString *)localizeCanonicalUnitWithCanonicalUnit:(nonnull YRTCanonicalUnit *)canonicalUnit;
/**
 * Localization preferences.
 */
@property (nonatomic, nonnull) YRTI18nPrefs *prefs;
/**
 * System of measurement used.
 */
@property (nonatomic) YRTSystemOfMeasurement som;
/**
 * Preferred time format.
 */
@property (nonatomic) YRTTimeFormat timeFormat;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end

/**
 * Undocumented
 */
@interface YRTI18nManagerFactory : NSObject

/**
 * Returns the locale currently used by the runtime. Should be called
 * only after locale has been set.
 */
+ (nonnull NSString *)getLocale;

/**
 * Sets the application's locale. Useful only if MapKit is not used by
 * the application. Otherwise, use {@code
 * mapkit.MapKitFactory.setLocale()}. Also useless if someone else has
 * already set the locale (produses warning and does nothing). Can be
 * set to none, in this case system locale will be used.
 */
+ (void)setLocaleWithLocale:(nullable NSString *)locale;

/**
 * Gets the internationalization manager interface.
 */
+ (nonnull YRTI18nManager *)getI18nManagerInstance;

@end
