#import <YandexMapsMobile/YRTEcPublicKey.h>

@class YRTAttestationListener;

/**
 * :nodoc:
 */
@protocol YRTPlatformKeystore <NSObject>

/**
 * Returns true if there is a generated platform key.
 *
 * This method will be called on a background thread.
 */
- (BOOL)hasKey;

/**
 * Generates platform key.
 *
 * This method will be called on a background thread.
 */
- (void)generateKeyWithChallenge:(nonnull NSData *)challenge;

/**
 * Removes platform key.
 *
 * This method will be called on a background thread.
 */
- (void)removeKey;

/**
 * Get application id. For the purposes of attestation frameworks it can
 * differ from general purpose one.
 *
 * This method will be called on a background thread.
 */
- (nullable NSString *)getApplicationId;

/**
 * Returns platform keystore key proof. On Android it is a certificate
 * chain, on iOS it is exported public  secondary key.
 *
 * This method will be called on a background thread.
 */
- (nonnull NSData *)getKeystoreProof;

/**
 * Returns App Attest key id that is used for signing secondary key. Do
 * not call on Android.
 *
 * This method will be called on a background thread.
 */
- (nonnull NSString *)getAppAttestKeyId;

/**
 * Returns AppAttest assertion for secondary key. Do not call on
 * Android.
 *
 * This method will be called on a background thread.
 */
- (nonnull NSData *)getAppAttestKeyAssertion;

/**
 * Returns public key information for stored key.
 *
 * This method will be called on a background thread.
 */
- (nonnull YRTEcPublicKey *)getEcPublicKey;

/**
 * Requests key attestation from service used in implementation of this
 * interface.
 *
 * This method will be called on a background thread.
 */
- (void)requestAttestKeyWithChallenge:(nonnull NSData *)challenge
                   cloudProjectNumber:(long long)cloudProjectNumber
                  attestationListener:(nonnull YRTAttestationListener *)attestationListener;

/**
 * Signs data with private key that is in the platform keystore.
 *
 * This method will be called on a background thread.
 */
- (nonnull NSData *)ecSignWithData:(nonnull NSData *)data;

@end
