#import <Foundation/Foundation.h>

/**
 * The .h generated from this idl should define the same entities as
 * libs/i18n/include/yandex/maps/i18n/prefs.h from the mapscore repo.
 * Please edit these two files simultaneously. The system of measurement
 * to use.
 */
typedef NS_ENUM(NSUInteger, YRTSystemOfMeasurement) {
    /**
     * Undocumented
     */
    YRTSystemOfMeasurementDefault,
    /**
     * Metric system. (kilometers etc)
     */
    YRTSystemOfMeasurementMetric,
    /**
     * Imperial system. (miles etc)
     */
    YRTSystemOfMeasurementImperial
};

/**
 * Time format to use.
 */
typedef NS_ENUM(NSUInteger, YRTTimeFormat) {
    /**
     * Undocumented
     */
    YRTTimeFormatDefault,
    /**
     * 24-hour time format.
     */
    YRTTimeFormatH24,
    /**
     * 12-hour time format with AM/PM marker.
     */
    YRTTimeFormatH12
};

/**
 * Localization preferences.
 */
@interface YRTI18nPrefs : NSObject

/**
 * System of measurement (metric or imperial).
 */
@property (nonatomic, readonly) YRTSystemOfMeasurement som;

/**
 * Time format (12- or 24-hour).
 */
@property (nonatomic, readonly) YRTTimeFormat timeFormat;


+ (nonnull YRTI18nPrefs *)i18nPrefsWithSom:( YRTSystemOfMeasurement)som
                                timeFormat:( YRTTimeFormat)timeFormat;


@end
