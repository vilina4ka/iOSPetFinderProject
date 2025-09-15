#import <YandexMapsMobile/YMKJamSegment.h>

#import <UIKit/UIKit.h>

/**
 * Color for specific level of traffic intensity.
 */
@interface YMKJamTypeColor : NSObject

/**
 * The type of the traffic jam.
 */
@property (nonatomic, readonly) YMKJamType jamType;

/**
 * Traffic jam color.
 */
@property (nonatomic, readonly, nonnull) UIColor *jamColor;


+ (nonnull YMKJamTypeColor *)jamTypeColorWithJamType:( YMKJamType)jamType
                                            jamColor:(nonnull UIColor *)jamColor;


@end

/**
 * The style that is used to display traffic intensity.
 */
@interface YMKJamStyle : NSObject

/**
 * Collection of colors for traffic intensity.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKJamTypeColor *> *colors;


+ (nonnull YMKJamStyle *)jamStyleWithColors:(nonnull NSArray<YMKJamTypeColor *> *)colors;


@end
