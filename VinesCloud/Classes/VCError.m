#import "VCError.h"

@implementation VCError

@synthesize errorId;
@synthesize statusCode;
@synthesize cause;

- (id)initWithId:(NSString *)anErrorId statusCode:(NSNumber *)status cause:(NSError *)error
{
    if (self = [super init]) {
        errorId = anErrorId;
        statusCode = status;
        cause = error;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"VCError: id=%@ status=%@ cause=%@", errorId, statusCode, cause];
}

@end
