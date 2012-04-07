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

- (void)save:(NSMutableDictionary *)object callback:(VCObjectResultBlock)callback
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    void (^block)(NSMutableDictionary *, NSHTTPURLResponse *, VCError *) = ^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
            return;
        }
        NSString *location = [[response allHeaderFields] objectForKey:@"Location"];
        if (location) {
            NSArray *pieces = [location componentsSeparatedByString:@"/"];
            NSString *objectId = [pieces objectAtIndex:[pieces count] - 1];
            [object setObject:objectId forKey:@"id"];
        }
        callback(object, nil);
    };

    if ([object valueForKey:@"id"]) {
        NSString *url = [NSString stringWithFormat:@"/%@", [object valueForKey:@"id"]];
        VCRequest *request = [VCRequest putWithUrl:[self url:url]];
        [request executeWithBody:json callback:block];
    } else {
        VCRequest *request = [VCRequest postWithUrl:[self url:@""]];
        [request executeWithBody:json callback:block];
    }
}

- (void)removeById:(NSString *)objectId callback:(VCObjectResultBlock)callback
{
    NSMutableDictionary *criteria = [[NSMutableDictionary alloc] initWithObjectsAndKeys:objectId, @"id", nil];
    [self remove:criteria callback:callback];
}

- (void)remove:(NSMutableDictionary *)object callback:(VCObjectResultBlock)callback
{
    NSString *url = [NSString stringWithFormat:@"/%@", [object valueForKey:@"id"]];
    VCRequest *request = [VCRequest deleteWithUrl:[self url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            callback(object, nil);
        }
    }];
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