#import <Foundation/Foundation.h>
#import "VCResource.h"

@interface VCStorage : VCResource {
    NSURL *baseUrl;
}

@property (readonly, retain) NSString *className;

- (id)initWithBaseUrl:(NSURL *)baseUrl className:(NSString *)className;

@end
