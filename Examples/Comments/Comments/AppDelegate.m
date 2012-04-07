#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self authenticateWithVinesCloud];
    return YES;
}

/*
 * Replace the domain, username, and password below with the settings for your
 * Vines Cloud account. All Vines Cloud API calls must occur after authenticating
 * with a valid user (except new user signup, of course).
 */
- (void)authenticateWithVinesCloud
{
    NSString *domain = @"wonderland.getvines.com";
    NSString *username = @"alice@wonderland.getvines.com";
    NSString *password = @"password";

    vines = [[VinesCloud alloc] initWithDomain:domain];
    [vines authenticateWithUsername:username password:password callback:^(NSMutableDictionary *user, VCError *error) {
        NSLog(@"user: authentication %@ %@", user, error);
        if (user) [self findVinesApps];
    }];
}

/*
 * A single Vines Cloud account may host several mobile apps. Find the list of
 * apps in the account and use the first app for the rest of the example code.
 */
- (void)findVinesApps {
    VCQuery *query = [vines.apps query];
    [query count:^(NSNumber *count, VCError *error) {
        if (error) {
            NSLog(@"app: count failed %@", error);
        } else {
            NSLog(@"app: count %@", count);
        }
    }];
    
    [query all:^(NSMutableArray *rows, VCError *error) {
        if (error) {
            NSLog(@"app: find failed %@", error);
            return;
        }
        NSLog(@"app: found %@", rows);
        VCApp *app = [rows objectAtIndex:0];
        [query find:app.nick callback:^(NSMutableDictionary *found, VCError *error) {
            if (error) {
                NSLog(@"app: find failed %@", error);
            } else {
                NSLog(@"app: found %@", found);
                VCApp *app = (VCApp *)found;
                [self registerUser];
                [self storeComments:app];
                [self publishToChannels:app];
            }
        }];
    }];
}

/*
 * Signup a new user account, then immediately delete the user.
 */
- (void)registerUser
{
    VCQuery *query = [vines.users query];
    [query count:^(NSNumber *count, VCError *error) {
        if (error) {
            NSLog(@"user: count failed %@", error);
        } else {
            NSLog(@"user: count %@", count);
        }
    }];

    [query limit:10 skip:0];
    [query all:^(NSMutableArray *found, VCError *error) {
        if (error) {
            NSLog(@"user: find failed %@", error);
        } else {
            NSLog(@"user: found %@", found);
        }
    }];
    
    NSString *username = [NSString stringWithFormat:@"demo-user@%@", vines.domain];
    NSMutableDictionary *signup = [NSMutableDictionary dictionaryWithObjectsAndKeys:username, @"id", @"passw0rd", @"password", nil];
    [vines.users save:signup callback:^(NSMutableDictionary *result, VCError *error) {
        if (error) {
            NSLog(@"user: save failed %@", error);
        } else {
            NSLog(@"user: save succeeded %@", result);
            [self deleteUser:username];
        }
    }];
}

/*
 * Find a Vines Cloud user account by its ID, then delete the user.
 */
- (void)deleteUser:(NSString *)username
{
    VCQuery *query = [vines.users query];
    [query find:username callback:^(NSMutableDictionary *found, VCError *error) {
        if (error) {
            NSLog(@"user: find failed %@", error);
            return;
        }
        NSLog(@"user: found by id %@", found);
        [vines.users removeById:[found objectForKey:@"id"] callback:^(NSMutableDictionary *deleted, VCError *error) {
            if (error) {
                NSLog(@"user: delete failed %@", error);
            } else {
                NSLog(@"user: delete succeeded %@", deleted);
            }
        }];
    }];
}

/*
 * Demonstrates how to find the list of Vines Cloud storage classes in which
 * JSON objects may be stored, counting, saving, querying, and deleting example
 * Comment objects.
 */
- (void)storeComments:(VCApp *)app
{
    [app classes:^(NSMutableArray *rows, VCError *error) {
        for (VCStorage *storage in rows) {
            NSLog(@"storage: found class %@", [storage className]);
        }
    }];
    
    VCStorage *comments = [app storageForClass:@"Comment"];
    VCQuery *query = [comments query];
    [query count:^(NSNumber *count, VCError *error) {
        if (error) {
            NSLog(@"comment: count failed %@", error);
        } else {
            NSLog(@"comment: count %@", count);
        }
    }];

    // complex query with where clause
    query = [comments query:@"text exists and text like :match"];
    [query whereKey:@"match" is:@"comment!"];
    [query count:^(NSNumber *count, VCError *error) {
        if (error) {
            NSLog(@"comment: count failed %@", error);
        } else {
            NSLog(@"comment: count %@", count);
        }
    }];

    // find first matching comment object
    [query first:^(NSMutableDictionary *obj, VCError *error) {
        if (error) {
            NSLog(@"comment: find first failed %@", error);
        } else {
            NSLog(@"comment: found first %@", obj);
        }
    }];
    
    // use limit and skip to find first 10 comments
    query = [comments query];
    [query limit:10 skip:0];
    [query all:^(NSMutableArray *rows, VCError *error) {
        if (error) {
            NSLog(@"comment: find failed %@", error);  
        } else {
            NSLog(@"comment: found first 10 %@", rows);
        }
    }];
    
    NSMutableDictionary *comment = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a comment!", @"text", nil];
    [comments save:comment callback:^(NSMutableDictionary *result, VCError *error) {
        if (error) {
            NSLog(@"comment: save failed %@", error);
        } else {
            NSLog(@"comment: save succeeded %@", result);
            [result setObject:@"This is an updated comment!" forKey:@"text"];
            [comments save:result callback:^(NSMutableDictionary *result, VCError *error) {
                NSLog(@"comment: update succeeded %@", result);
                [self deleteComment:[result valueForKey:@"id"] comments:comments];
            }];
        }
    }];
}

/*
 * Find a storage object by its ID, then delete it.
 */
- (void)deleteComment:(NSString *)commentId comments:(VCStorage *)comments
{
    VCQuery *query = [comments query];
    [query find:commentId callback:^(NSMutableDictionary *found, VCError *error) {
        if (error) {
            NSLog(@"comment: find failed %@", error);
            return;
        }
        NSLog(@"comment: found by id %@", found);
        [comments removeById:[found objectForKey:@"id"] callback:^(NSMutableDictionary *deleted, VCError *error) {
            if (error) {
                NSLog(@"comment: delete failed %@", error);
            } else {
                NSLog(@"comment: delete succeeded %@", deleted);
            }
        }];
    }];
}

/*
 * Create a "comments" pubsub channel, subscribe to its stream of messages, and
 * publish comments to it. Send messages to the comments channel from the Vines
 * Cloud web console to see them appear in this demo app.
 */
- (void)publishToChannels:(VCApp *)app
{
    __block int received = 0;

    commentsChannel = [app channelForName:@"comments"];
    [commentsChannel subscribe:^(NSMutableDictionary *message) {
        NSLog(@"comment: received message %d on channel %@", received, message);
        received++;
    }];

    NSDictionary *comment = [self commentForString:@"This is a comment!"];
    [commentsChannel publish:comment];
    
    NSDictionary *comment2 = [self commentForString:@"This is another comment!"];
    [commentsChannel publish:comment2];
}

/*
 * Return a comment suitable for publishing to a pubsub channel.
 */
- (NSMutableDictionary *)commentForString:(NSString *)text
{
    NSNumber *no = [NSNumber numberWithBool:NO];
    NSMutableDictionary *comment = [[NSMutableDictionary alloc] init];
    [comment setObject:text forKey:@"text"];
    [comment setObject:no forKey:@"spam"];
    return comment;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
