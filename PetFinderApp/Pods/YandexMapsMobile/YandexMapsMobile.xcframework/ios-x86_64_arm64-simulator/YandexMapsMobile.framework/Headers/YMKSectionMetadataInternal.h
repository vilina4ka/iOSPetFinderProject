#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKMasstransitRoute.h>

/**
 * :nodoc:
 * It is not to be used in platform code
 */
@interface YMKSectionMetadataInternal : NSObject<YMKBaseMetadata>

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitSectionMetadata *metadata;

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL isPassThroughTransportSection;


+ (nonnull YMKSectionMetadataInternal *)sectionMetadataInternalWithMetadata:(nonnull YMKMasstransitSectionMetadata *)metadata
                                              isPassThroughTransportSection:( BOOL)isPassThroughTransportSection;


@end
