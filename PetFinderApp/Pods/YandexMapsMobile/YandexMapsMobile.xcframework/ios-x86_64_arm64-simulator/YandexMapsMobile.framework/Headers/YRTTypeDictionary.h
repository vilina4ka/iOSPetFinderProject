#import <Foundation/Foundation.h>

/// :nodoc:
@interface YRTTypeDictionary<__covariant T> : NSObject

- (nullable T)getItemOfClass:(nonnull Class)cls;

- (nonnull instancetype)initWithValues:(nonnull NSArray<T>*)values;

@end
