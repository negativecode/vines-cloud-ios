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

- (void)classes:(VCListResultBlock)callback
{
    VCRequest *request = [VCRequest getWithUrl:[self url:@"/classes"]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            NSArray *rows = [result valueForKey:@"rows"];
            NSMutableArray *built = [[NSMutableArray alloc] init];
            for (NSDictionary *row in rows) {
                id storage = [[VCStorage alloc] initWithBaseUrl:[self url:@""] className:[row objectForKey:@"name"]];
                [built addObject: storage];
            }
            callback(built, nil);
        }
    }];
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
