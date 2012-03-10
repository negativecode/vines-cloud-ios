#import <Foundation/Foundation.h>

@interface VCError : NSObject

@property (readonly, retain) NSString *errorId;
@property (readonly, retain) NSNumber *statusCode;
@property (readonly, retain) NSError *cause;

- (id)initWithId:(NSString *)anErrorId statusCode:(NSNumber *)status cause:(NSError *)error;

@end
