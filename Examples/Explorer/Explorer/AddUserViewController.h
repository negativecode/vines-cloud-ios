#import <UIKit/UIKit.h>

@class AddUserViewController;

@protocol AddUserViewControllerDelegate <NSObject>
- (void)addUserViewControllerDidCancel:(AddUserViewController *)controller;
- (void)addUserViewController:(AddUserViewController *)controller didAddUser:(NSMutableDictionary *)user;
@end

@interface AddUserViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *userIDText;
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (weak) id <AddUserViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
