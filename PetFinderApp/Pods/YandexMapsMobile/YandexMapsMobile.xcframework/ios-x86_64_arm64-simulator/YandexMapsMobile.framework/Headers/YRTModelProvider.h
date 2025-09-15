#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// :nodoc:
@protocol YRTModelProvider

- (NSString*)modelId;
- (NSData*)model;
- (UIImage*)texture;

@end
