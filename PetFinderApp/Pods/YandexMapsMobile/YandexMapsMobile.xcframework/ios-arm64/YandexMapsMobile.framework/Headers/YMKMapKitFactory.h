#import <YandexMapsMobile/YMKMapkit.h>

@interface YMKMapKit (Factory)

/// Gets the MapKit instance.
+ (nonnull instancetype)mapKit;
+ (nonnull instancetype)sharedInstance;
/// Sets the API key for MapKit SDK. Call this before [YMKMapKit mapKit] and [YMKMapKit sharedInstance]
+ (void)setApiKey:(nonnull NSString*)apiKey;
/// Sets the user id for MapKit SDK. Call this before [YMKMapKit mapKit] and [YMKMapKit sharedInstance]
+ (void)setUserId:(nonnull NSString*)id;
/// Sets locale for MapKit SDK. Call this before [YMKMapKit mapKit] and [YMKMapKit sharedInstance]
+ (void)setLocale:(nullable NSString*)locale;
/// Sets completion handler for background URL session.
- (void)setCompletionHandler:(nonnull void (^)(void))completionHandler
     forBackgroundURLSession:(nonnull NSString *)identifier;

@end
