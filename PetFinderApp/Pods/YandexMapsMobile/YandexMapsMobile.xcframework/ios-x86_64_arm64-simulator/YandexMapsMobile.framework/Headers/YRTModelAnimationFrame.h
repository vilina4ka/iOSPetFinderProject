#import <Foundation/Foundation.h>
#import <YandexMapsMobile/YRTModelProvider.h>

/// :nodoc:
@interface YRTModelAnimationFrame : NSObject

- (id)initWithModel:(id<YRTModelProvider>)model duration:(NSTimeInterval)duration;
- (id<YRTModelProvider>)model;
- (NSTimeInterval)duration;

@end
