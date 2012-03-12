#import <Foundation/Foundation.h>
#import "VCError.h"

@interface VCResource : NSObject

- (id)init;

- (void)count:(VCCountResultBlock)callback;

- (void)find:(NSDictionary *)options callback:(VCObjectResultBlock)callback;

- (void)findById:(NSString *)objectId callback:(VCObjectResultBlock)callback;

- (void)all:(NSDictionary *)options callback:(VCListResultBlock)callback;

- (void)all:(NSDictionary *)options limit:(int)limit skip:(int)skip callback:(VCListResultBlock)callback;

- (void)save:(NSMutableDictionary *)object callback:(VCObjectResultBlock)callback;

- (void)remove:(NSMutableDictionary *)options callback:(VCObjectResultBlock)callback;

- (void)removeById:(NSString *)objectId callback:(VCObjectResultBlock)callback;

- (id)build:(NSMutableDictionary *)object;

- (NSURL *)url:(NSString *)fragment;

@end
