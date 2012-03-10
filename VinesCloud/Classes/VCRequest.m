#import "VCRequest.h"
#import "VCDelegate.h"

@implementation VCRequest

- (id)initWithUrl:(NSURL *)aUrl method:(NSString *)aMethod
{
    if (self = [super init]) {
        url = aUrl;
        method = aMethod;
        headers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)execute:(void (^)(NSMutableDictionary *, NSHTTPURLResponse *, VCError *))callback
{
    [self executeWithBody:nil callback:callback];
}

- (void)executeWithBody:(NSString *)body callback:(void (^)(NSMutableDictionary *, NSHTTPURLResponse *, VCError *))callback
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    if (body) {
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    for (id key in headers) {
        [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    VCDelegate *delegate = [[VCDelegate alloc] initWithCallback:callback];
    [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
}

- (void)setValue:(NSString *)value forHeader:(NSString *)header
{
    [headers setValue:value forKey:header];
}

+ (VCRequest *)getWithUrl:(NSURL *)url
{
    return [[VCRequest alloc] initWithUrl:url method:@"GET"];
}

+ (VCRequest *)deleteWithUrl:(NSURL *)url
{
    return [[VCRequest alloc] initWithUrl:url method:@"DELETE"];    
}

+ (VCRequest *)postWithUrl:(NSURL *)url
{
    return [[VCRequest alloc] initWithUrl:url method:@"POST"];
}

+ (VCRequest *)putWithUrl:(NSURL *)url
{
    return [[VCRequest alloc] initWithUrl:url method:@"PUT"];
}

@end
