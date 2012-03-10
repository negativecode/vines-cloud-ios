#import <Foundation/Foundation.h>
#import "VCError.h"

@interface VCRequest : NSObject {
    NSString *method;
    NSURL *url;
    NSMutableDictionary *headers;
}

+ (VCRequest *)getWithUrl:(NSURL *)url;

+ (VCRequest *)deleteWithUrl:(NSURL *)url;

+ (VCRequest *)postWithUrl:(NSURL *)url;

+ (VCRequest *)putWithUrl:(NSURL *)url;

- (id)initWithUrl:(NSURL *)aUrl method:(NSString *)aMethod;

- (void)execute:(void (^)(NSMutableDictionary *result, NSHTTPURLResponse *, VCError *error))callback;

- (void)executeWithBody:(NSString *)body callback:(void (^)(NSMutableDictionary *result, NSHTTPURLResponse *, VCError *error))callback;

- (void)setValue:(NSString *)value forHeader:(NSString *)header;

@end
