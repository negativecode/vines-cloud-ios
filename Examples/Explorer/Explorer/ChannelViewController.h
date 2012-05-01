#import <UIKit/UIKit.h>
#import "VinesCloud/VCChannel.h"

@interface ChannelViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextView *messagesText;
@property (strong, nonatomic) IBOutlet UITextField *messageText;
@property (strong) VCChannel *channel;

@end
