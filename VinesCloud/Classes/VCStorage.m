#import "VCStorage.h"

@implementation VCStorage

@synthesize className;

- (id)initWithBaseUrl:(NSURL *)url className:(NSString *)aClassName
{
    if (self = [super init]) {
        baseUrl = url;
        className = aClassName;
    }
    return self;
}

- (NSURL *)url:(NSString *)fragment
{
    NSString *resource = [NSString stringWithFormat:@"/classes/%@%@", className, fragment];
    NSString *full = [NSString stringWithFormat:@"%@%@", [baseUrl absoluteString], resource];
    return [NSURL URLWithString:full];
}

@end
