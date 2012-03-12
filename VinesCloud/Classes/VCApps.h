#import <Foundation/Foundation.h>
#import "VCResource.h"

@class VinesCloud;

@interface VCApps : VCResource {
    NSURL *baseUrl;
    VinesCloud *vines;
}

- (id)initWithBaseUrl:(NSURL *)baseUrl vines:(VinesCloud *)vines;

@end
