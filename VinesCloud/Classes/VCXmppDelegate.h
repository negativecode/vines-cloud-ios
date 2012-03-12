#import <Foundation/Foundation.h>
#import "VCError.h"

@interface VCXmppDelegate : NSObject {
    NSString *password;
    void (^callback)(VCError *error);
}

- (id)initWithPassword:(NSString *)aPassword callback:(void (^)(VCError *error))aCallback;

@end
