#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * Describes data attached to features in user layer.
 */
@interface YMKUserData : NSObject<YMKBaseMetadata>

/**
 * A dictionary of data.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, NSString *> *data;


+ (nonnull YMKUserData *)userDataWithData:(nonnull NSDictionary<NSString *, NSString *> *)data;


@end
