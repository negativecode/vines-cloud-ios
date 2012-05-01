#import <UIKit/UIKit.h>
#import "VinesCloud/VinesCloud.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong) VinesCloud *vines;
@property (strong) VCApp *vinesApp;
@property (strong) VCDeferred *appLoaded;

- (void)authenticateWithVinesCloud;
- (void)findApp;

@end
