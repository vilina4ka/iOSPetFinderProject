#import <YandexMapsMobile/YMKMrcPhotoPlayer.h>
#import <YandexMapsMobile/YRTLifecycleProvider.h>
#import <UIKit/UIKit.h>

/** Undocumented */
@interface YMKMrcPhotoView : UIView

@property (strong, nonatomic, readonly) YMKMrcPhotoPlayer *player;

- (id)initWithFrame:(CGRect)frame vulkanPreferred:(bool)vulkanPreferred;
- (id)initWithFrame:(CGRect)frame
    vulkanPreferred:(bool)vulkanPreferred
  lifecycleProvider:(id<YRTLifecycleProvider>)lifecycleProvider;
- (void)setNoninteractive:(bool)is;

@end
