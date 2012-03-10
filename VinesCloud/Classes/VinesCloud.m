#import "VinesCloud.h"
#import "VCRequest.h"

@implementation VinesCloud

@synthesize domain;
@synthesize apps;
@synthesize users;

- (id)initWithDomain:(NSString *)aDomain
{
    if (self = [super init]) {
        domain = aDomain;
        NSString *url = [[NSString alloc] initWithFormat:@"http://%@", domain];
        baseUrl = [NSURL URLWithString: url];
        users = [[VCUsers alloc] initWithBaseUrl:baseUrl];
        apps = [[VCApps alloc] initWithBaseUrl:baseUrl];
    }
    return self;
}

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password callback:(void(^)(NSMutableDictionary *, VCError *))callback
{
    username = [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    password = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    
    NSString *body = [[NSString alloc] initWithFormat:@"username=%@&password=%@", username, password];
    
    NSURL *url = [NSURL URLWithString: @"/login" relativeToURL:baseUrl];
    VCRequest *request = [VCRequest postWithUrl:url];
    [request setValue:@"application/x-www-form-urlencoded" forHeader:@"Content-Type"];
    [request executeWithBody:body callback:^(NSMutableDictionary *result, NSHTTPURLResponse *response, VCError *error) {
        if (error) {
            callback(nil, error);
        } else {
            callback(result, nil);
        }
    }];
}

@end
