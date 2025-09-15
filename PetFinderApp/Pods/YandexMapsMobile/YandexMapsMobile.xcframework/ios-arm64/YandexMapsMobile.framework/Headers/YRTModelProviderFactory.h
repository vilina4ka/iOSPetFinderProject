#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YandexMapsMobile/YRTModelProvider.h>

/// :nodoc:
@interface YRTModelProviderFactory : NSObject

+ (id<YRTModelProvider>)fromFile:(NSString*)path texture:(UIImage*)texture;
+ (id<YRTModelProvider>)fromData:(NSData*)data texture:(UIImage*)texture;

@end
