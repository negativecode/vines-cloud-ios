#import <UIKit/UIKit.h>
#import <VinesCloud/VinesCloud.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    VinesCloud *vines;
}

@property (strong, nonatomic) UIWindow *window;

- (void)authenticateWithVinesCloud;

@end
