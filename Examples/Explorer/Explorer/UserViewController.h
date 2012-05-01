#import <UIKit/UIKit.h>

@interface UserViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *userIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (strong) NSMutableDictionary *user;

@end
