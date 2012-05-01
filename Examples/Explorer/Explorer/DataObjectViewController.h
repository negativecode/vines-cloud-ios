#import <UIKit/UIKit.h>

@interface DataObjectViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *jsonText;
@property (strong) NSMutableDictionary *dataObject;

@end
