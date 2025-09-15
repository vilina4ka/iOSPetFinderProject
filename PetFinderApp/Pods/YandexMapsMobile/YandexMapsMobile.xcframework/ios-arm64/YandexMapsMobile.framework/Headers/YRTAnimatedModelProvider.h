#import <Foundation/Foundation.h>
#import <YandexMapsMobile/YRTAnimatedModel.h>

/// :nodoc:
@protocol YRTAnimatedModelProvider

- (NSString*)modelId;
- (YRTAnimatedModel*)model;

@end
