#import <YandexMapsMobile/YMKMrcPhotoTrackPlayer.h>
#import <YandexMapsMobile/YRTLifecycleProvider.h>
#import <UIKit/UIKit.h>

/** Undocumented */
@interface YMKMrcPhotoTrackView : UIView

@property (strong, nonatomic, readonly) YMKMrcPhotoTrackPlayer *player;

- (id)initWithFrame:(CGRect)frame vulkanPreferred:(bool)vulkanPreferred;
- (id)initWithFrame:(CGRect)frame
    vulkanPreferred:(bool)vulkanPreferred
  lifecycleProvider:(id<YRTLifecycleProvider>)lifecycleProvider;
- (void)setNoninteractive:(bool)is;

@end
