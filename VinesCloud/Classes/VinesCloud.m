#import "VinesCloud.h"
#import "VCRequest.h"
#import "VCXmppDelegate.h"

@implementation VinesCloud

@synthesize domain;
@synthesize apps;
@synthesize users;
@synthesize xmppStream;

- (id)initWithDomain:(NSString *)aDomain
{
    if (self = [super init]) {
        domain = aDomain;
        NSString *url = [[NSString alloc] initWithFormat:@"https://%@", domain];
        baseUrl = [NSURL URLWithString: url];
        users = [[VCUsers alloc] initWithBaseUrl:baseUrl];
        apps = [[VCApps alloc] initWithBaseUrl:baseUrl vines:self];
    }
    return self;
}

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password callback:(VCObjectResultBlock)callback
{
    username = [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    password = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    
    NSString *body = [[NSString alloc] initWithFormat:@"username=%@&password=%@", username, password];

    NSURL *url = [NSURL URLWithString: @"/login" relativeToURL:baseUrl];
    VCRequest *request = [VCRequest postWithUrl:url];
    [request setValue:@"application/x-www-form-urlencoded" forHeader:@"Content-Type"];
    [request executeWithBody:body callback:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            [self connectXmppStreamWithUser:result password:password callback:callback];
        }
    }];
}

- (void)connectXmppStreamWithUser:(NSMutableDictionary *)user password:(NSString *)password callback:(VCObjectResultBlock)callback
{
    NSString *username = [user objectForKey:@"id"];
    XMPPJID *jid = [XMPPJID jidWithString:username];
    xmppStream = [[XMPPStream alloc] init];
    xmppStream.myJID = jid;
    xmppStream.hostName = [jid domain];
    xmppStream.hostPort = 5222;

    void (^block)(VCError *) = ^(VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            callback(user, nil);
        }
    };

    xmppDelegate = [[VCXmppDelegate alloc] initWithPassword:password callback:block];
    [xmppStream addDelegate:xmppDelegate delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    if (![xmppStream connect:&error]) {
        VCError *err = [[VCError alloc] initWithId:@"xmpp-conn-failed" statusCode:nil cause:error];
        callback(nil, err);
    }
}

@end
