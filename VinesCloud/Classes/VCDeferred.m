#import "VCDeferred.h"

@implementation VCDeferred

- (id)init
{
    if (self = [super init]) {
        done = [[NSMutableArray alloc] init];
        fail = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)done:(VCDeferredDoneBlock)callback
{
    if (failed) return;
    if (resolved) {
        callback(result);
    } else {
        [done addObject:[callback copy]];   
    }
}

- (void)fail:(VCDeferredFailBlock)callback
{
    if (resolved) return;
    if (failed) {
        callback((VCError *)result);
    } else {
        [fail addObject:[callback copy]];
    }
}

- (void)resolve:(id)theResult
{
    if (resolved || failed) return;
    resolved = true;
    result = theResult;
    for (VCDeferredDoneBlock callback in done) {
        callback(result);
    }
    [done removeAllObjects];
    [fail removeAllObjects];
}

- (void)reject:(id)error
{
    if (resolved || failed) return;
    failed = true;
    result = error;
    for (VCDeferredFailBlock callback in done) {
        callback(error);
    }
    [done removeAllObjects];
    [fail removeAllObjects];
}

@end
