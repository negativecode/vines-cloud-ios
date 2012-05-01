#import <UIKit/UIKit.h>

@class AddDataObjectViewController;

@protocol AddDataObjectViewControllerDelegate <NSObject>
- (void)addDataObjectViewControllerDidCancel:(AddDataObjectViewController *)controller;
- (void)addDataObjectViewController:(AddDataObjectViewController *)controller didAddObject:(NSMutableDictionary *)object;
@end

@interface AddDataObjectViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *keyText;
@property (strong, nonatomic) IBOutlet UITextField *valueText;
@property (weak, nonatomic) id <AddDataObjectViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
