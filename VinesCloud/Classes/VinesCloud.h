#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "VCApp.h"
#import "VCApps.h"
#import "VCChannel.h"
#import "VCDelegate.h"
#import "VCDeferred.h"
#import "VCError.h"
#import "VCResource.h"
#import "VCRequest.h"
#import "VCStorage.h"
#import "VCUsers.h"
#import "VCQuery.h"
#import "VCXmppDelegate.h"

@class VCApps;

@interface VinesCloud : NSObject {
    NSURL *baseUrl;
    VCXmppDelegate *xmppDelegate;
}

@property (readonly, strong) NSString *domain;
@property (readonly, strong) VCApps *apps;
@property (readonly, strong) VCUsers *users;
@property (readonly, strong) XMPPStream *xmppStream;

- (id)initWithDomain:(NSString *)domain;

- (VCDeferred *)authenticateWithUsername:(NSString *)username password:(NSString *)password callback:(VCObjectResultBlock)callback;

- (void)connectXmppStreamWithUser:(NSMutableDictionary *)user password:(NSString *)password callback:(VCObjectResultBlock)callback deferred:(VCDeferred *)deferred;

@end
