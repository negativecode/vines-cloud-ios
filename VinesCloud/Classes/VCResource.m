#import "VCResource.h"
#import "VCDelegate.h"
#import "VCRequest.h"
#import "VCError.h"

@implementation VCResource

- (id)init
{
    if (self = [super init]) {

    }
    return self;
}

- (VCQuery *)query
{
    return [[VCQuery alloc] initWithResource:self];
}

- (VCQuery *)query:(NSString *)queryString
{
    VCQuery *query = [[VCQuery alloc] initWithResource:self];
    [query where:queryString];
    return query;
}

- (VCQuery *)query:(NSString *)queryString criteria:(NSDictionary *)criteria
{
    VCQuery *query = [[VCQuery alloc] initWithResource:self];
    [query where:queryString criteria:criteria];
    return query;
}

- (VCQuery *)queryWithCriteria:(NSDictionary *)criteria
{
    VCQuery *query = [[VCQuery alloc] initWithResource:self];
    [query where:@"" criteria:criteria];
    return query;    
}

- (VCDeferred *)save:(NSMutableDictionary *)object
{
    return [self save:object callback:nil];
}

- (VCDeferred *)save:(NSMutableDictionary *)object callback:(VCObjectResultBlock)callback
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    VCDeferred *deferred = [[VCDeferred alloc] init];
    void (^block)(NSMutableDictionary *, NSHTTPURLResponse *, VCError *) = ^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            if (callback) callback(nil, error);
            [deferred reject:error];
            return;
        }
        NSString *location = [[response allHeaderFields] objectForKey:@"Location"];
        if (location) {
            NSArray *pieces = [location componentsSeparatedByString:@"/"];
            NSString *objectId = [pieces objectAtIndex:[pieces count] - 1];
            [object setObject:objectId forKey:@"id"];
        }
        if (callback) callback(object, nil);
        [deferred resolve:object];
    };

    if ([object valueForKey:@"id"]) {
        NSString *url = [NSString stringWithFormat:@"/%@", [object valueForKey:@"id"]];
        VCRequest *request = [VCRequest putWithUrl:[self url:url]];
        [request executeWithBody:json callback:block];
    } else {
        VCRequest *request = [VCRequest postWithUrl:[self url:@""]];
        [request executeWithBody:json callback:block];
    }
    return deferred;
}

- (VCDeferred *)removeById:(NSString *)objectId
{
    return [self removeById:objectId callback:nil];
}

- (VCDeferred *)removeById:(NSString *)objectId callback:(VCObjectResultBlock)callback
{
    NSMutableDictionary *criteria = [[NSMutableDictionary alloc] initWithObjectsAndKeys:objectId, @"id", nil];
    return [self remove:criteria callback:callback];
}

- (VCDeferred *)remove:(NSMutableDictionary *)object
{
    return [self remove:object callback:nil];
}

- (VCDeferred *)remove:(NSMutableDictionary *)object callback:(VCObjectResultBlock)callback
{
    VCDeferred *deferred = [[VCDeferred alloc] init];
    NSString *url = [NSString stringWithFormat:@"/%@", [object valueForKey:@"id"]];
    VCRequest *request = [VCRequest deleteWithUrl:[self url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            if (callback) callback(nil, error);
            [deferred reject:error];
        } else {
            if (callback) callback(object, nil);
            [deferred resolve:object];
        }
    }];
    return deferred;
}

- (id)build:(NSMutableDictionary *)object
{
    return object;
}

- (NSURL *)url:(NSString *)fragment
{
    return nil;
}

@end