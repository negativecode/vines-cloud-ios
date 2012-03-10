#import "VCUsers.h"

@implementation VCUsers

- (id)initWithBaseUrl:(NSURL *)url
{
    if (self = [super init]) {
        baseUrl = url;
    }
    return self;
}

- (NSURL *)url:(NSString *)fragment
{
    NSString *resource = [NSString stringWithFormat:@"/users%@", fragment];
    return [NSURL URLWithString:resource relativeToURL:baseUrl];
}

@end
