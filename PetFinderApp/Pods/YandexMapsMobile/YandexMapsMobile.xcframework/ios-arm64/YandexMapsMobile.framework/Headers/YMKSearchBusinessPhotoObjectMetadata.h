#import <YandexMapsMobile/YMKBaseMetadata.h>

@class YMKSearchBusinessPhotoObjectMetadataPhoto;
@class YMKSearchPhotoPhotoLink;

/**
 * Snippet for company-related photos (becoming obsolete).
 */
@interface YMKSearchBusinessPhotoObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * Number of photos for the organisation. (see PhotosManager for
 * details)
 */
@property (nonatomic, readonly) NSUInteger count;

/**
 * List of photos for the company (usually first three)
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchBusinessPhotoObjectMetadataPhoto *> *photos;


+ (nonnull YMKSearchBusinessPhotoObjectMetadata *)businessPhotoObjectMetadataWithCount:( NSUInteger)count
                                                                                photos:(nonnull NSArray<YMKSearchBusinessPhotoObjectMetadataPhoto *> *)photos;


@end

/**
 * Information about single photos.
 */
@interface YMKSearchBusinessPhotoObjectMetadataPhoto : NSObject

/**
 * To get a valid download link use the value of id + /[size], where
 * [size] is one of: 1. XXXS 2. XXS 3. XS 4. S 5. M 6. L 7. XL 8. XXL 9.
 * XXXL 10. orig
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Photo links.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchPhotoPhotoLink *> *links;


+ (nonnull YMKSearchBusinessPhotoObjectMetadataPhoto *)photoWithId:(nonnull NSString *)id
                                                             links:(nonnull NSArray<YMKSearchPhotoPhotoLink *> *)links;


@end

/**
 * Photo link details.
 */
@interface YMKSearchPhotoPhotoLink : NSObject

/**
 * Optional link type, for example "panorama".
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *type;

/**
 * Link URI.
 */
@property (nonatomic, readonly, nonnull) NSString *uri;


+ (nonnull YMKSearchPhotoPhotoLink *)photoLinkWithType:(nullable NSString *)type
                                                   uri:(nonnull NSString *)uri;


@end
