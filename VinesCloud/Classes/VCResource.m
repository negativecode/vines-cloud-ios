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

- (void)count:(VCCountResultBlock)callback
{
    VCRequest *request = [VCRequest getWithUrl:[self url:@"?limit=1"]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            callback([result valueForKey:@"total"], nil);
        }
    }];
}

- (void)findById:(NSString *)objectId callback:(VCObjectResultBlock)callback
{
    NSDictionary *criteria = [[NSDictionary alloc] initWithObjectsAndKeys:objectId, @"id", nil];
    [self find:criteria callback:callback];
}

- (void)find:(NSDictionary *)options callback:(VCObjectResultBlock)callback
{
    NSString *url = [NSString stringWithFormat:@"/%@", [options valueForKey:@"id"]];
    VCRequest *request = [VCRequest getWithUrl:[self url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            callback([self build:result], nil);
        }
    }];
}

- (void)all:(NSDictionary *)options callback:(VCListResultBlock)callback
{
    [self all:options limit:500 skip:0 callback:callback];
}

- (void)all:(NSDictionary *)options limit:(int)limit skip:(int)skip callback:(VCListResultBlock)callback
{
    NSString *url = [[NSString alloc] initWithFormat:@"?limit=%d&skip=%d", limit, skip];
    VCRequest *request = [VCRequest getWithUrl:[self url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            NSArray *rows = [result valueForKey:@"rows"];
            NSMutableArray *built = [[NSMutableArray alloc] init];
            for (NSMutableDictionary *row in rows) {
                [built addObject: [self build:row]];
            }
            callback(built, nil);
        }
    }];
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

- (void)remove:(NSMutableDictionary *)options callback:(VCObjectResultBlock)callback
{
    NSString *url = [NSString stringWithFormat:@"/%@", [options valueForKey:@"id"]];
    VCRequest *request = [VCRequest deleteWithUrl:[self url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            callback(options, nil);
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