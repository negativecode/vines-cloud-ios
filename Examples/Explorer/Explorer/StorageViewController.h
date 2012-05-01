#import <UIKit/UIKit.h>
#import "AddStorageClassViewController.h"

@interface StorageViewController : UITableViewController <AddStorageClassViewControllerDelegate>

@property (strong) NSMutableArray *storageClasses;

@end
