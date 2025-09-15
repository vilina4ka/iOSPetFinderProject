#import <YandexMapsMobile/YMKImagesImageUrlProvider.h>

/**
 * Undocumented
 */
@interface YMKBaseDataSourceBuilder : NSObject

/**
 * The class does not retain the object in the 'urlProvider' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)setImageUrlProviderWithUrlProvider:(nonnull id<YMKImagesImageUrlProvider>)urlProvider;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
