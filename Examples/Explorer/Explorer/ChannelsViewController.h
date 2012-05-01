#import <UIKit/UIKit.h>
#import "AddChannelViewController.h"

@interface ChannelsViewController : UITableViewController <AddChannelViewControllerDelegate>

@property (strong) NSMutableArray *channels;

@end
