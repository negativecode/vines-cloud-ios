#import <UIKit/UIKit.h>
#import "VinesCloud/VCStorage.h"
#import "AddDataObjectViewController.h"

@interface StorageClassViewController : UITableViewController <AddDataObjectViewControllerDelegate>

@property (strong) VCStorage *storageClass;
@property (strong) NSMutableArray *dataObjects;

@end
