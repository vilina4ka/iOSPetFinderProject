#import <Foundation/Foundation.h>

@class YMKTrafficLevel;

/**
 * The color that is used for traffic.
 */
typedef NS_ENUM(NSUInteger, YMKTrafficColor) {
    /**
     * Red color.
     */
    YMKTrafficColorRed,
    /**
     * Yellow color.
     */
    YMKTrafficColorYellow,
    /**
     * Green color.
     */
    YMKTrafficColorGreen
};

/**
 * Listener to handle traffic information.
 */
@protocol YMKTrafficDelegate <NSObject>

/**
 * Triggered when traffic level changes.
 */
- (void)onTrafficChangedWithTrafficLevel:(nullable YMKTrafficLevel *)trafficLevel;

/**
 * Triggered when traffic information is loading.
 */
- (void)onTrafficLoading;

/**
 * Triggered when traffic information expires.
 */
- (void)onTrafficExpired;

@end

/**
 * The level of traffic.
 */
@interface YMKTrafficLevel : NSObject

/**
 * The color that represents traffic.
 */
@property (nonatomic, readonly) YMKTrafficColor color;

/**
 * Traffic level.
 */
@property (nonatomic, readonly) NSInteger level;


+ (nonnull YMKTrafficLevel *)trafficLevelWithColor:( YMKTrafficColor)color
                                             level:( NSInteger)level;


@end
