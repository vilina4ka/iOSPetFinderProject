#import <Foundation/Foundation.h>

/**
 * Indicates whether the suggested route has one or more of the
 * specified properties.
 */
@interface YMKMasstransitFlags : NSObject

/**
 * Indicates whether the suggested route requires an access pass.
 */
@property (nonatomic, readonly) BOOL requiresAccessPass;

/**
 * Indicates whether the suggested route includes automotive roads.
 */
@property (nonatomic, readonly) BOOL hasAutoRoad;


+ (nonnull YMKMasstransitFlags *)flagsWithRequiresAccessPass:( BOOL)requiresAccessPass
                                                 hasAutoRoad:( BOOL)hasAutoRoad;


@end
