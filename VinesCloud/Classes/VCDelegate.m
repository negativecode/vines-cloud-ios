#import "VCDelegate.h"

@implementation VCDelegate

@synthesize responseData;

- (id)initWithCallback:(void(^)(NSMutableDictionary *, NSHTTPURLResponse *, VCError *))aCallback
{
    if (self = [super init]) {
        callback = aCallback;
        response = nil;
        responseData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse
{
    [responseData setLength:0];
    response = (NSHTTPURLResponse *)urlResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *result = [self parseJson:responseString];
    VCError *error = nil;
    if ([response statusCode] >= 300) {
        NSString *errorId = @"unknown-error";
        NSMutableDictionary *err = [result objectForKey:@"error"];
        if (err) errorId = [err objectForKey:@"id"];
        NSNumber *status = [NSNumber numberWithLong:[response statusCode]];
        error = [[VCError alloc] initWithId:errorId statusCode:status cause:nil];
    }
    callback(result, response, error);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)cause
{
    NSNumber *status = nil;
    if (response) {
        status = [NSNumber numberWithLong:[response statusCode]];
    }
    VCError *error = [[VCError alloc] initWithId:@"unknown-error" statusCode:status cause:cause];
    callback(nil, response, error);
}

- (NSMutableDictionary *)parseJson:(NSString *)json
{
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *parseError;
    int options = NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers;
    NSMutableDictionary *parsed = [NSJSONSerialization JSONObjectWithData:jsonData options:options error:&parseError];
    return parsed;
}

@end
