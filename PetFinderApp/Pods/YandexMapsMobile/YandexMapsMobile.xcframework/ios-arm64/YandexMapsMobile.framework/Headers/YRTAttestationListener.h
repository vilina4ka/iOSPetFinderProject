#import <Foundation/Foundation.h>

/**
 * :nodoc:
 */
@interface YRTAttestationListener : NSObject

/**
 * Attestation was received.
 *
 * This method will be called on a background thread.
 */
- (void)onAttestationReceivedWithResponse:(nonnull NSData *)response;

/**
 * An error occurred during Attestation request.
 *
 * This method will be called on a background thread.
 */
- (void)onAttestationFailedWithMessage:(nonnull NSString *)message;

@end
