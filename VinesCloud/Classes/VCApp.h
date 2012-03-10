#import <Foundation/Foundation.h>
#import "VCStorage.h"

@interface VCApp : NSObject {
    NSURL *baseUrl;
}

@property (readonly, retain) NSString *name;
@property (readonly, retain) NSString *nick;
@property (readonly, retain) NSString *pubsub;

- (id)initWithBaseUrl:(NSURL *)url values:(NSDictionary *)object;

- (void)classes:(void(^)(NSMutableArray *rows, VCError *error))callback;

- (VCStorage *)storageForClass:(NSString *)className;

- (NSURL *)url:(NSString *)fragment;

@end
