#import <Foundation/Foundation.h>
#import "VCError.h"

@interface VCResource : NSObject

- (id)init;

- (void)count:(void(^)(NSNumber *, VCError *))callback;

- (void)find:(NSDictionary *)options callback:(void(^)(NSMutableDictionary *found, VCError *error))callback;

- (void)findById:(NSString *)objectId callback:(void(^)(NSMutableDictionary *, VCError *))callback;

- (void)all:(NSDictionary *)options callback:(void(^)(NSMutableArray *rows, VCError *error))callback;

- (void)all:(NSDictionary *)options limit:(int)limit skip:(int)skip callback:(void(^)(NSMutableArray *rows, VCError *error))callback;

- (void)save:(NSMutableDictionary *)object callback:(void(^)(NSMutableDictionary *saved, VCError *error))callback;

- (void)remove:(NSMutableDictionary *)options callback:(void(^)(NSMutableDictionary *deleted, VCError *error))callback;

- (void)removeById:(NSString *)objectId callback:(void(^)(NSMutableDictionary *, VCError *))callback;

- (id)build:(NSMutableDictionary *)object;

- (NSURL *)url:(NSString *)fragment;

@end
