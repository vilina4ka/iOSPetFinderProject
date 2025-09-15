#import <YandexMapsMobile/YMKImagesImageUrlProvider.h>

/// :nodoc:
@interface YMKImagesDefaultUrlProvider : NSObject<YMKImagesImageUrlProvider>

- (NSString *)formatUrlWithDescriptor:(YMKImagesImageDataDescriptor *)descriptor;

- (void)setUrlBase:(NSString *)urlBase;

@end
