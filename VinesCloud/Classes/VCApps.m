#import "VCApps.h"
#import "VCApp.h"

@implementation VCApps

- (id)initWithBaseUrl:(NSURL *)url vines:(VinesCloud *)client
{
    if (self = [super init]) {
        baseUrl = url;
        vines = client;
    }
    return self;
}

- (NSURL *)url:(NSString *)fragment
{
    NSString *resource = [NSString stringWithFormat:@"/apps%@", fragment];
    return [NSURL URLWithString:resource relativeToURL:baseUrl];
}

- (id)build:(NSMutableDictionary *)object
{
    return [[VCApp alloc] initWithBaseUrl:baseUrl values:object vines:vines];
}

@end
