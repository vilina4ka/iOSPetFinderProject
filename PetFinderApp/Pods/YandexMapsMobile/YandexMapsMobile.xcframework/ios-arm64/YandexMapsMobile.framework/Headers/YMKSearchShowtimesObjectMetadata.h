#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKTaxiMoney.h>
#import <YandexMapsMobile/YMKTime.h>

/**
 * Session details.
 */
@interface YMKSearchShowtime : NSObject

/**
 * Session start time.
 */
@property (nonatomic, readonly, nonnull) YMKTime *startTime;

/**
 * Ticket price.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKTaxiMoney *price;

/**
 * Ticket id.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *ticketId;


+ (nonnull YMKSearchShowtime *)showtimeWithStartTime:(nonnull YMKTime *)startTime
                                               price:(nullable YMKTaxiMoney *)price
                                            ticketId:(nullable NSString *)ticketId;


@end

/**
 * Event schedule snippet.
 */
@interface YMKSearchShowtimesObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * Event title.
 */
@property (nonatomic, readonly, nonnull) NSString *title;

/**
 * List of showtimes.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchShowtime *> *showtimes;


+ (nonnull YMKSearchShowtimesObjectMetadata *)showtimesObjectMetadataWithTitle:(nonnull NSString *)title
                                                                     showtimes:(nonnull NSArray<YMKSearchShowtime *> *)showtimes;


@end
