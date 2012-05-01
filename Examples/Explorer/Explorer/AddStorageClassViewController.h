#import <UIKit/UIKit.h>

@class AddStorageClassViewController;

@protocol AddStorageClassViewControllerDelegate <NSObject>
- (void)addStorageClassViewControllerDidCancel:(AddStorageClassViewController *)controller;
- (void)addStorageClassViewController:(AddStorageClassViewController *)controller didAddStorageClass:(NSString *)className;
@end

@interface AddStorageClassViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) id <AddStorageClassViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
