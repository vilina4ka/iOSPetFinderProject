#import <YandexMapsMobile/YMKPanoramaPlayer.h>
#import <YandexMapsMobile/YRTLifecycleProvider.h>
#import <UIKit/UIKit.h>

/** Undocumented */
@interface YMKPanoView : UIView

@property (strong, nonatomic, readonly) YMKPanoramaPlayer *player;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithFrame:(CGRect)frame vulkanPreferred:(bool)vulkanPreferred;
- (id)initWithFrame:(CGRect)frame scaleFactor:(float)scaleFactor vulkanPreferred:(bool)vulkanPreferred;
- (id)initWithFrame:(CGRect)frame
    vulkanPreferred:(bool)vulkanPreferred
  lifecycleProvider:(id<YRTLifecycleProvider>)lifecycleProvider;
- (id)initWithFrame:(CGRect)frame
        scaleFactor:(float)scaleFactor
    vulkanPreferred:(bool)vulkanPreferred
  lifecycleProvider:(id<YRTLifecycleProvider>)lifecycleProvider;
- (void)setNoninteractive:(bool)is;

@end
