#import <Foundation/Foundation.h>
#import "VCResource.h"

@interface VCUsers : VCResource {
    NSURL *baseUrl;
}

- (id)initWithBaseUrl:(NSURL *)baseUrl;

@end
