#import "VCApp.h"
#import "VCRequest.h"
#import "VCStorage.h"

@implementation VCApp

@synthesize name;
@synthesize nick;
@synthesize pubsub;
@synthesize vines;

- (id)initWithBaseUrl:(NSURL *)url values:(NSDictionary *)object vines:(VinesCloud *)client
{
    if (self = [super init]) {
        baseUrl = url;
        name = [object objectForKey:@"name"];
        nick = [object objectForKey:@"nick"];
        pubsub = [object objectForKey:@"pubsub"];
        vines = client;
    }
    return self;
}

- (VCDeferred *)classes
{
    return [self classes:nil];
}

- (VCDeferred *)classes:(VCListResultBlock)callback
{
    VCDeferred *deferred = [[VCDeferred alloc] init];
    VCRequest *request = [VCRequest getWithUrl:[self url:@"/classes"]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            if (callback) callback(nil, error);
            [deferred reject:error];
        } else {
            NSArray *rows = [result valueForKey:@"rows"];
            NSMutableArray *built = [[NSMutableArray alloc] init];
            for (NSDictionary *row in rows) {
                id storage = [[VCStorage alloc] initWithBaseUrl:[self url:@""] className:[row objectForKey:@"name"]];
                [built addObject: storage];
            }
            if (callback) callback(built, nil);
            [deferred resolve:built];
        }
    }];
    return deferred;
}

- (VCDeferred *)channels
{
    return [self channels:nil];
}

- (VCDeferred *)channels:(VCListResultBlock)callback
{
    VCDeferred *deferred = [[VCDeferred alloc] init];
    VCRequest *request = [VCRequest getWithUrl:[self url:@"/channels"]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            if (callback) callback(nil, error);
            [deferred reject:error];
        } else {
            NSArray *rows = [result valueForKey:@"rows"];
            NSMutableArray *built = [[NSMutableArray alloc] init];
            for (NSDictionary *row in rows) {
                id channel = [[VCChannel alloc] initWithName:[row objectForKey:@"name"] app:self];
                [built addObject: channel];
            }
            if (callback) callback(built, nil);
            [deferred resolve:built];
        }
    }];
    return deferred;
}

- (VCStorage *)storageForClass:(NSString *)className
{
    return [[VCStorage alloc] initWithBaseUrl:[self url:@""] className:className];
}

- (VCChannel *)channelForName:(NSString *)channelName
{
    return [[VCChannel alloc] initWithName:channelName app:self];
}

- (NSURL *)url:(NSString *)fragment
{
    NSString *resource = [NSString stringWithFormat:@"/apps/%@%@", nick, fragment];
    return [NSURL URLWithString:resource relativeToURL:baseUrl];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"VCApp: name=%@ nick=%@ pubsub=%@", name, nick, pubsub];
}

@end
