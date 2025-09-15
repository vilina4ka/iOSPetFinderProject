#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKSearchRelatedPlaces.h>

/**
 * Snippet data to get related places info.
 */
@interface YMKSearchRelatedPlacesObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * List of similar places.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchPlaceInfo *> *similarPlaces;


+ (nonnull YMKSearchRelatedPlacesObjectMetadata *)relatedPlacesObjectMetadataWithSimilarPlaces:(nonnull NSArray<YMKSearchPlaceInfo *> *)similarPlaces;


@end
