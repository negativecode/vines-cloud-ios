#import <Foundation/Foundation.h>

@interface VCError : NSObject

@property (readonly, strong) NSString *errorId;
@property (readonly, strong) NSNumber *statusCode;
@property (readonly, strong) NSError *cause;

- (id)initWithId:(NSString *)anErrorId statusCode:(NSNumber *)status cause:(NSError *)error;

@end

typedef void (^VCObjectResultBlock)(NSMutableDictionary *, VCError *);
typedef void (^VCListResultBlock)(NSMutableArray *, VCError *);
typedef void (^VCCountResultBlock)(NSNumber *, VCError *);
