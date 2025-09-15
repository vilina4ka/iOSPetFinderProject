#pragma once

#import <UIKit/UIKit.h>

/// :nodoc:
typedef NS_ENUM(NSUInteger, YRTTouchEventType) {
    YRTTouchEventTypeBegan,
    YRTTouchEventTypeEnded,
    YRTTouchEventTypeMoved,
    YRTTouchEventTypeCancelled
};

/// :nodoc:
@interface YRTTouchEvent : NSObject

@property (nonatomic, assign) YRTTouchEventType type;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, strong) NSDictionary *pointers;

- (instancetype)initWithEventType:(YRTTouchEventType)type
                        timestamp:(NSTimeInterval)timestamp
                   scaledCgPoints:(NSDictionary *)scaledCgPoints;

- (instancetype)initWithEvent:(UIEvent *)event
                         type:(YRTTouchEventType)type
                         view:(UIView *)view;

@end
