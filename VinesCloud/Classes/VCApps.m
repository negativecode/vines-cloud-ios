#import "VCApps.h"
#import "VCApp.h"

@implementation VCApps

- (id)initWithBaseUrl:(NSURL *)url
{
    if (self = [super init]) {
        baseUrl = url;
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
    return [[VCApp alloc] initWithBaseUrl:baseUrl values:object];
}

@end
