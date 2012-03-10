#import <Foundation/Foundation.h>
#import "VCError.h"

@interface VCDelegate : NSObject <NSURLConnectionDelegate> {
    NSMutableData *responseData;
    NSHTTPURLResponse *response;
    void (^callback)(NSMutableDictionary *, NSHTTPURLResponse *, VCError *);
}

@property (retain) NSMutableData *responseData;

- (id)initWithCallback:(void(^)(NSMutableDictionary *, NSHTTPURLResponse *, VCError *))aCallback;

- (NSMutableDictionary *)parseJson:(NSString *)json;

@end
