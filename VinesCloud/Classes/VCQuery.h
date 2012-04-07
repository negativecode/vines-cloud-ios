#import <Foundation/Foundation.h>
#import "VCRequest.h"
#import "VCResource.h"

@class VCResource;

@interface VCQuery : NSObject {
    VCResource *resource;
    NSString *query;
    NSMutableDictionary *criteria;
    int limit;
    int skip;
}

- (id)initWithResource:(VCResource *)resource;

- (void)limit:(int)limit skip:(int)skip;

- (void)whereKey:(NSString *)key is:(NSObject *)value;

- (void)where:(NSString *)queryString;

- (void)where:(NSString *)queryString criteria:(NSDictionary *)criteria;

- (void)find:(NSString *)objectId callback:(VCObjectResultBlock)callback;

- (void)all:(VCListResultBlock)callback;

- (void)first:(VCObjectResultBlock)callback;

- (void)count:(VCCountResultBlock)callback;

- (NSString *)urlEncodeString:(NSString *)string;

- (NSString *)jsonEncodeObject:(NSDictionary *)object;

@end
