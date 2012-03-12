#import "VCXmppDelegate.h"
#import "VCError.h"
#import "XMPPJID.h"
#import "XMPPMessage.h"
#import "XMPPStream.h"

@implementation VCXmppDelegate

- (id)initWithPassword:(NSString *)aPassword callback:(void (^)(VCError *error))aCallback
{
    if (self = [super init]) {
        password = aPassword;
        callback = aCallback;
    }
    return self;
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{

}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{

}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{

}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	NSError *error = nil;
	if (![sender authenticateWithPassword:password error:&error]) {
        VCError *err = [[VCError alloc] initWithId:@"xmpp-auth-failed" statusCode:nil cause:error];
        password = nil;
        callback(err);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    password = nil;
    callback(nil);
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    VCError *err = [[VCError alloc] initWithId:@"xmpp-auth-failed" statusCode:nil cause:nil];
    password = nil;
    callback(err);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{

}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{

}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{

}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{

}

@end
