#import <UIKit/UIKit.h>
#import "AddUserViewController.h"

@interface UsersViewController : UITableViewController <AddUserViewControllerDelegate>

@property (strong) NSMutableArray *users;

@end
