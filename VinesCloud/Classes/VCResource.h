#import <Foundation/Foundation.h>
#import "VCError.h"
#import "VCQuery.h"

@class VCQuery;

@interface VCResource : NSObject

- (id)init;

- (VCQuery *)query;

- (VCQuery *)query:(NSString *)queryString;

- (VCQuery *)query:(NSString *)queryString criteria:(NSDictionary *)criteria;

- (VCQuery *)queryWithCriteria:(NSDictionary *)criteria;

- (VCDeferred *)save:(NSMutableDictionary *)object callback:(VCObjectResultBlock)callback;

- (VCDeferred *)remove:(NSMutableDictionary *)options callback:(VCObjectResultBlock)callback;

- (VCDeferred *)removeById:(NSString *)objectId callback:(VCObjectResultBlock)callback;

- (id)build:(NSMutableDictionary *)object;

- (NSURL *)url:(NSString *)fragment;

@end
