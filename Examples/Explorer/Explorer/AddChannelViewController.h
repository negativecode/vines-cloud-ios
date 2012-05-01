#import <UIKit/UIKit.h>

@class AddChannelViewController;

@protocol AddChannelViewControllerDelegate <NSObject>
- (void)addChannelViewControllerDidCancel:(AddChannelViewController *)controller;
- (void)addChannelViewController:(AddChannelViewController *)controller didAddChannel:(NSString *)channelName;
@end

@interface AddChannelViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <AddChannelViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *nameText;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
