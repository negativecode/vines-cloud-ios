#import <Foundation/Foundation.h>
#import "VCStorage.h"
#import "VinesCloud.h"

@class VinesCloud;
@class VCChannel;
@class VCDeferred;

@interface VCApp : NSObject {
    NSURL *baseUrl;
}

@property (readonly, strong) NSString *name;
@property (readonly, strong) NSString *nick;
@property (readonly, strong) NSString *pubsub;
@property (readonly, strong) VinesCloud *vines;

- (id)initWithBaseUrl:(NSURL *)url values:(NSDictionary *)object vines:(VinesCloud *)vines;

- (VCDeferred *)classes;
- (VCDeferred *)classes:(VCListResultBlock)callback;

- (VCDeferred *)channels;
- (VCDeferred *)channels:(VCListResultBlock)callback;

- (VCStorage *)storageForClass:(NSString *)className;

- (VCChannel *)channelForName:(NSString *)name;

- (NSURL *)url:(NSString *)fragment;

@end
