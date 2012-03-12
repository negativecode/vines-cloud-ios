#import "VCChannel.h"
#import "XMPPJID.h"
#import "XMPPPubSub.h"

@implementation VCChannel

@synthesize name;
@synthesize app;

- (id)initWithName:(NSString *)aName app:(VCApp *)anApp
{
    if (self = [super init]) {
        name = aName;
        app = anApp;
        subscribers = [[NSMutableArray alloc] init];
        XMPPJID *jid = [XMPPJID jidWithString:anApp.pubsub];
        pubsub = [[XMPPPubSub alloc] initWithServiceJID:jid];
        [pubsub activate:app.vines.xmppStream];
        [pubsub addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

/*
 * Write the object to the pubsub channel, serializing it to JSON first.
 */
- (void)publish:(NSDictionary *)object
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:[pubsub serviceJID] elementID:app.vines.xmppStream.generateUUID];
    NSXMLElement *ps = [NSXMLElement elementWithName:@"pubsub" xmlns:@"http://jabber.org/protocol/pubsub"];
    NSXMLElement *publish = [NSXMLElement elementWithName:@"publish"];
    [publish addAttributeWithName:@"node" stringValue:name];

    NSXMLElement *item = [NSXMLElement elementWithName:@"item"];
    NSXMLElement *payload = [NSXMLElement elementWithName:@"payload" xmlns:@"http://getvines.com/cloud"];
    [payload setStringValue:json];

    [item addChild:payload];
    [publish addChild:item];
    [ps addChild:publish];
    [iq addChild:ps];

    [app.vines.xmppStream sendElement:iq];
}

/*
 * Register a callback to be notified when this channel receives a message.
 */
- (void)subscribe:(VCChannelSubscriber)callback
{
    [pubsub createNode:name withOptions:nil];
    [pubsub subscribeToNode:name withOptions:nil];
    [subscribers addObject:[callback copy]];
}

/*
 * Unsubscribe all callbacks from the channel.
 */
- (void)unsubscribe
{
    [subscribers removeAllObjects];
    [pubsub unsubscribeFromNode:name];
}

/*
 * Parse the JSON payload embedded in the message received from a pubsub channel.
 * Returns a dictionary with three possible keys:
 * - publisher: (NSString) contains the JID of the user that sent this message
 *   to the channel
 * - payload: (NSMutableDictionary) the JSON object embedded in the message
 *   stanza.
 * - error: (NSError) the error generated during JSON parsing of the payload. If
 *   this key is in the dictionary, there will be no payload key.
 *
 * Returns nil if the message contains no payload element or was not addressed
 * to this channel.
 */
- (NSMutableDictionary *)parseMessage:(XMPPMessage *)message
{
    NSXMLElement *event = [message elementForName:@"event"];
    NSXMLElement *items = [event elementForName:@"items"];
    NSXMLElement *item = [items elementForName:@"item"];
    NSXMLElement *payload = [item elementForName:@"payload"];
    NSString *channel = [items attributeStringValueForName:@"node"];
    NSString *publisher = [item attributeStringValueForName:@"publisher"];

    if (!payload) return nil;
    if (![name isEqualToString:channel]) return nil;    

    NSData *jsonData = [[payload stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    int options = NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers;
    NSMutableDictionary *parsed = [NSJSONSerialization JSONObjectWithData:jsonData options:options error:&error];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:publisher forKey:@"publisher"];
    if (error) {
        [result setObject:error forKey:@"error"];
    } else {
        [result setObject:parsed forKey:@"payload"];
    }
    return result;
}

- (void)xmppPubSub:(XMPPPubSub *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSMutableDictionary *object = [self parseMessage:message];
    if (!object) return;
    for (VCChannelSubscriber subscriber in subscribers) {
        subscriber(object);
    }
}

@end
