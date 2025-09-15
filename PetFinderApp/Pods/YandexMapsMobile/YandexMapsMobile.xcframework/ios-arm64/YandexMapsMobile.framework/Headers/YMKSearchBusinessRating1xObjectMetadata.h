#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * Snippet for company ratings. Score from 0 to 5.
 */
@interface YMKSearchBusinessRating1xObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * Total number of ratings.
 */
@property (nonatomic, readonly) NSUInteger ratings;

/**
 * Total number of reviews.
 */
@property (nonatomic, readonly) NSUInteger reviews;

/**
 * Average rating score for the company (0 to 5).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *score;


+ (nonnull YMKSearchBusinessRating1xObjectMetadata *)businessRating1xObjectMetadataWithRatings:( NSUInteger)ratings
                                                                                       reviews:( NSUInteger)reviews
                                                                                         score:(nullable NSNumber *)score;


@end
