#import <YandexMapsMobile/YMKMapWindow.h>
#import <YandexMapsMobile/YRTGraphicsApiType.h>
#import <YandexMapsMobile/YRTLifecycleProvider.h>
#import <YandexMapsMobile/YRTTouchEvent.h>

#import <UIKit/UIKit.h>

@interface YMKMapView : UIView

@property (nonatomic, readonly) YMKMapWindow *mapWindow;

- (void)setNoninteractive:(bool)is;

- (id)initWithCoder:(NSCoder *)aDecoder;

- (id)initWithFrame:(CGRect)frame;

/// :nodoc:
- (id)initWithFrame:(CGRect)frame vulkanPreferred:(BOOL)vulkanPreferred;

/// :nodoc:
- (id)initWithFrame:(CGRect)frame
        scaleFactor:(float)scaleFactor
    vulkanPreferred:(BOOL)vulkanPreferred
  lifecycleProvider:(id<YRTLifecycleProvider>)lifecycleProvider;

/// :nodoc:
- (enum YRTGraphicsAPIType)getGraphicsAPI;

/// :nodoc:
- (void)handleTouchEvent:(YRTTouchEvent *)touchEvent;

@end
