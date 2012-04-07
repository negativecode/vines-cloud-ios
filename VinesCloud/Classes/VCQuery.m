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

- (void)find:(NSString *)objectId callback:(VCObjectResultBlock)callback
{
    NSString *url = [NSString stringWithFormat:@"/%@", objectId];
    VCRequest *request = [VCRequest getWithUrl:[resource url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            callback([resource build:result], nil);
        }
    }];
}

- (void)all:(VCListResultBlock)callback
{
    NSString *json = [self jsonEncodeObject:criteria];
    NSString *encodedQuery = [self urlEncodeString:query];
    NSString *encodedCriteria = [self urlEncodeString:json];
    NSString *url = [[NSString alloc] initWithFormat:@"?query=%@&criteria=%@&limit=%d&skip=%d", encodedQuery, encodedCriteria, limit, skip];
    
    VCRequest *request = [VCRequest getWithUrl:[resource url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            NSArray *rows = [result valueForKey:@"rows"];
            NSMutableArray *built = [[NSMutableArray alloc] init];
            for (NSMutableDictionary *row in rows) {
                [built addObject: [resource build:row]];
            }
            callback(built, nil);
        }
    }];
}

- (void)first:(VCObjectResultBlock)callback
{
    VCListResultBlock block = ^(NSMutableArray *rows, VCError *error) {
        if (error) {
            callback(nil, error);
            return;
        }
        if ([rows count] > 0) {
            NSMutableDictionary *first = [rows objectAtIndex:0];
            first = [resource build:first];
            callback(first, nil);
        } else {
            callback(nil, nil);
        }
    };

    limit = 1;
    skip = 0;
    [self all:block];
}

- (void)count:(VCCountResultBlock)callback
{
    NSString *json = [self jsonEncodeObject:criteria];
    NSString *encodedQuery = [self urlEncodeString:query];
    NSString *encodedCriteria = [self urlEncodeString:json];
    NSString *url = [[NSString alloc] initWithFormat:@"?query=%@&criteria=%@&limit=1", encodedQuery, encodedCriteria];
    
    VCRequest *request = [VCRequest getWithUrl:[resource url:url]];
    [request execute:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            callback([result valueForKey:@"total"], nil);
        }
    }];
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
