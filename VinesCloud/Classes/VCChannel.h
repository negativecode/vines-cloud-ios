#import <Foundation/Foundation.h>
#import "VCApp.h"
#import "XMPPPubSub.h"

@class VCApp;

typedef void(^VCChannelSubscriber)(NSMutableDictionary *message);

@interface VCChannel : NSObject {
    XMPPPubSub *pubsub;
    NSMutableArray *subscribers;
}

@property (readonly, strong) NSString *name;
@property (readonly, strong) VCApp *app;

- (id)initWithName:(NSString *)name app:(VCApp *)app;

- (void)publish:(NSDictionary *)object;

- (void)subscribe:(VCChannelSubscriber)callback;

- (void)unsubscribe;

- (NSMutableDictionary *)parseMessage:(XMPPMessage *)message;

@end
