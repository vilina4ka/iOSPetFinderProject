#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * Undocumented
 */
@interface YMKSearchOrgOwnershipObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *canBeClaimed;


+ (nonnull YMKSearchOrgOwnershipObjectMetadata *)orgOwnershipObjectMetadataWithCanBeClaimed:(nullable NSNumber *)canBeClaimed;


@end
