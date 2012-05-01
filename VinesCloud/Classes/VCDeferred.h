#import <Foundation/Foundation.h>
#import "VCError.h"

typedef void (^VCDeferredDoneBlock)(NSObject *found);
typedef void (^VCDeferredFailBlock)(VCError *error);

@interface VCDeferred : NSObject {
    NSMutableArray *done;
    NSMutableArray *fail;
    NSObject *result;
    bool resolved;
    bool failed;
}

- (void)done:(VCDeferredDoneBlock)callback;
- (void)fail:(VCDeferredFailBlock)callback;
- (void)resolve:(id)result;
- (void)reject:(id)error;

@end
