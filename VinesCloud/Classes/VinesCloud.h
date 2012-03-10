#import <Foundation/Foundation.h>
#import "VCApp.h"
#import "VCApps.h"
#import "VCDelegate.h"
#import "VCResource.h"
#import "VCRequest.h"
#import "VCStorage.h"
#import "VCUsers.h"

@interface VinesCloud : NSObject {
    NSURL *baseUrl;
}

@property (readonly, retain) NSString *domain;
@property (readonly, retain) VCApps *apps;
@property (readonly, retain) VCUsers *users;

- (id)initWithDomain:(NSString *)domain;

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password callback:(void(^)(NSMutableDictionary *user, VCError *error))callback;

@end
