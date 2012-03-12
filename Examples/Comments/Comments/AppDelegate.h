#import <UIKit/UIKit.h>
#import <VinesCloud/VinesCloud.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    VinesCloud *vines;
}

@property (strong, nonatomic) UIWindow *window;

- (void)authenticateWithVinesCloud;

- (void)findVinesApps;

- (void)registerUser;

- (void)deleteUser:(NSString *)username;

- (void)storeComments:(VCApp *)app;

- (void)deleteComment:(NSString *)commentId comments:(VCStorage *)comments;

- (void)publishToChannels:(VCApp *)app;

- (NSMutableDictionary *)commentForString:(NSString *)text;

@end
