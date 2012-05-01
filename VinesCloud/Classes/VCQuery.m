#import "VCQuery.h"

@implementation VCQuery

- (id)initWithResource:(VCResource *)aResource
{
    if (self = [super init]) {
        resource = aResource;
        limit = 100;
        skip = 0;
        criteria = [[NSMutableDictionary alloc] init];
        query = @"";
    }
    return self;
}

- (void)limit:(int)aLimit skip:(int)aSkip
{
    limit = aLimit;
    skip = aSkip;
}

- (void)whereKey:(NSString *)key is:(NSObject *)value;
{
    [criteria setValue:value forKey:key];
}

- (void)where:(NSString *)queryString
{
    query = queryString;
}

- (void)where:(NSString *)queryString criteria:(NSDictionary *)aCriteria
{
    query = queryString;
    [criteria addEntriesFromDictionary:aCriteria];
}

- (VCDeferred *)find:(NSString *)objectId callback:(VCObjectResultBlock)callback
{
    VCDeferred *deferred = [[VCDeferred alloc] init];
    NSString *url = [NSString stringWithFormat:@"/%@", objectId];
    VCRequest *request = [VCRequest getWithUrl:[resource url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
            [deferred reject:error];
        } else {
            id built = [resource build:result];
            callback(built, nil);
            [deferred resolve:built];
        }
    }];
    return deferred;
}

- (VCDeferred *)all:(VCListResultBlock)callback
{
    NSString *json = [self jsonEncodeObject:criteria];
    NSString *encodedQuery = [self urlEncodeString:query];
    NSString *encodedCriteria = [self urlEncodeString:json];
    NSString *url = [[NSString alloc] initWithFormat:@"?query=%@&criteria=%@&limit=%d&skip=%d", encodedQuery, encodedCriteria, limit, skip];

    VCDeferred *deferred = [[VCDeferred alloc] init];
    VCRequest *request = [VCRequest getWithUrl:[resource url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
            [deferred reject:error];
        } else {
            NSArray *rows = [result valueForKey:@"rows"];
            NSMutableArray *built = [[NSMutableArray alloc] init];
            for (NSMutableDictionary *row in rows) {
                [built addObject: [resource build:row]];
            }
            callback(built, nil);
            [deferred resolve:built];
        }
    }];
    return deferred;
}

- (VCDeferred *)first:(VCObjectResultBlock)callback
{
    VCDeferred *deferred = [[VCDeferred alloc] init];
    VCListResultBlock block = ^(NSMutableArray *rows, VCError *error) {
        if (error) {
            callback(nil, error);
            [deferred reject:error];
            return;
        }
        if ([rows count] > 0) {
            id first = [rows objectAtIndex:0];
            callback(first, nil);
            [deferred resolve:first];
        } else {
            callback(nil, nil);
            [deferred resolve:nil];
        }
    };

    limit = 1;
    skip = 0;
    [self all:block];
    return deferred;
}

- (VCDeferred *)count:(VCCountResultBlock)callback
{
    NSString *json = [self jsonEncodeObject:criteria];
    NSString *encodedQuery = [self urlEncodeString:query];
    NSString *encodedCriteria = [self urlEncodeString:json];
    NSString *url = [[NSString alloc] initWithFormat:@"?query=%@&criteria=%@&limit=1", encodedQuery, encodedCriteria];
    
    VCDeferred *deferred = [[VCDeferred alloc] init];
    VCRequest *request = [VCRequest getWithUrl:[resource url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
            [deferred reject:error];
        } else {
            id total = [result valueForKey:@"total"];
            callback(total, nil);
            [deferred resolve:total];
        }
    }];
    return deferred;
}

- (NSString *)urlEncodeString:(NSString *)string
{
    return (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}

- (NSString *)jsonEncodeObject:(NSDictionary *)object
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

@end
