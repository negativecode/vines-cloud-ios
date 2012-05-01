#import "ChannelViewController.h"

@implementation ChannelViewController

@synthesize messagesText;
@synthesize messageText;
@synthesize channel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.channel subscribe:^(NSMutableDictionary *message) {
        self.messagesText.text = [self.messagesText.text stringByAppendingString:message.description];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.channel unsubscribe];
}

- (void)viewDidUnload
{
    [self setMessageText:nil];
    [self setMessagesText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
    [message setObject:self.messageText.text forKey:@"message"];
    [self.channel publish:message];
    self.messageText.text = @"";
}

@end
