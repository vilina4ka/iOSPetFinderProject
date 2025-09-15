#import <Foundation/Foundation.h>

/**
 * :nodoc:
 */
@interface YRTEcPublicKey : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSData *affineX;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSData *affineY;


+ (nonnull YRTEcPublicKey *)ecPublicKeyWithAffineX:(nonnull NSData *)affineX
                                           affineY:(nonnull NSData *)affineY;


@end
