#import <Foundation/Foundation.h>
#import "VCResource.h"

@interface VCApps : VCResource {
    NSURL *baseUrl;
}

- (id)initWithBaseUrl:(NSURL *)baseUrl;

@end
