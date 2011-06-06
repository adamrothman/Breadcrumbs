//
//  BreadcrumbsAppDelegate.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BreadcrumbsAppDelegate.h"
#import "LocationMonitor.h"
#import "NearbyViewController.h"
#import "NoteBrowserViewController.h"
#import "TagBrowserViewController.h"
#import "ARGeoViewController.h"
#import "ARGeoCoordinate.h"
#import "Note.h"

@interface BreadcrumbsAppDelegate() <ARViewDelegate>
@property (nonatomic, readonly) LocationMonitor *locationMonitor;
@end

@implementation BreadcrumbsAppDelegate

@synthesize window=_window;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

@synthesize locationMonitor;

#pragma mark - Properties

- (LocationMonitor *)locationMonitor {
    return [LocationMonitor sharedMonitor];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.locationMonitor.managedObjectContext = self.managedObjectContext;
    
    NearbyViewController *nearby = [[[NearbyViewController alloc] initInManagedObjectContext:self.managedObjectContext] autorelease];
    UINavigationController *nearbynvc = [[[UINavigationController alloc] initWithRootViewController:nearby] autorelease];
    nearbynvc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Nearby"
                                                          image:[UIImage imageNamed:@"73-radar"]
                                                            tag:0] autorelease];
    
    NoteBrowserViewController *notes = [[[NoteBrowserViewController alloc] initWithStyle:UITableViewStylePlain
                                                                  inManagedObjectContext:self.managedObjectContext
                                                                                  forTag:nil] autorelease];
    UINavigationController *notesnvc = [[[UINavigationController alloc] initWithRootViewController:notes] autorelease];
    notesnvc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Notes"
                                                         image:[UIImage imageNamed:@"179-notepad"]
                                                           tag:1] autorelease];
    
    TagBrowserViewController *tags = [[[TagBrowserViewController alloc] initWithStyle:UITableViewStylePlain
                                                               inManagedObjectContext:self.managedObjectContext] autorelease];
    UINavigationController *tagsnvc = [[[UINavigationController alloc] initWithRootViewController:tags] autorelease];
    tagsnvc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Tags"
                                                           image:[UIImage imageNamed:@"15-tags"]
                                                             tag:2] autorelease];
    
    UIViewController *arnvc = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // This part is more of a proof of concept than anything else
        // it's pretty rough around the edges (there's no nice way to
        // dismiss the AR view so I had to do it on a timer) but still
        // cool. In future versions I'd like to make this more usable.
        
        ARGeoViewController *ar = [[ARGeoViewController alloc] init];
        ar.delegate = self;
        ar.scaleViewsBasedOnDistance = YES;
        ar.minimumScaleFactor = 0.5;
        ar.rotateViewsBasedOnPerspective = YES;
        
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        request.entity = [NSEntityDescription entityForName:@"Note"
                                     inManagedObjectContext:self.managedObjectContext];
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request
                                                                           error:NULL];
        for (Note *note in fetchedObjects) {
            ARGeoCoordinate *geoCoord = [ARGeoCoordinate coordinateWithLocation:note.location];
            geoCoord.title = note.title;
            
            [ar addCoordinate:geoCoord];
        }
        
        ar.centerLocation = self.locationMonitor.locationManager.location;
        
        [ar startListening];
        
        arnvc = [[[UINavigationController alloc] initWithRootViewController:ar] autorelease];
    } else {
        arnvc = [[[UIViewController alloc] initWithNibName:@"ARNotAvailable"
                                                    bundle:nil] autorelease];
    }
    arnvc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"AR"
                                                      image:[UIImage imageNamed:@"164-glasses-2"]
                                                        tag:3] autorelease];
    
    UITabBarController *tbc = [[[UITabBarController alloc] init] autorelease];
    tbc.viewControllers = [NSArray arrayWithObjects:nearbynvc, notesnvc, tagsnvc, arnvc, nil];
    
    self.window.rootViewController = tbc;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.locationMonitor.locationManager stopUpdatingLocation];
    [self.locationMonitor.locationManager startMonitoringSignificantLocationChanges];
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.locationMonitor.locationManager startUpdatingLocation];
    [self.locationMonitor.locationManager stopMonitoringSignificantLocationChanges];
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.locationMonitor.locationManager stopUpdatingLocation];
    [self.locationMonitor.locationManager stopMonitoringSignificantLocationChanges];
    
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    // do something here
}

- (void)awakeFromNib {
    /*
     Typically you should set up the Core Data stack here, usually by passing the managed object context to the first view controller.
     self.<#View controller#>.managedObjectContext = self.managedObjectContext;
    */
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Breadcrumbs" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Breadcrumbs.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - ARViewDelegate

- (UIView *)viewForCoordinate:(ARCoordinate *)coordinate {
    
#define BOX_WIDTH   150
#define BOX_HEIGHT  100
	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	UIView *tempView = [[UIView alloc] initWithFrame:theFrame];
	
	//tempView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.3];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BOX_WIDTH, 20.0)];
	titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = coordinate.title;
	[titleLabel sizeToFit];
	
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0, 0, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
	
	UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectZero];
	pointView.image = [UIImage imageNamed:@"location.png"];
	pointView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 - pointView.image.size.width / 2.0), (int)(BOX_HEIGHT / 2.0 - pointView.image.size.height / 2.0), pointView.image.size.width, pointView.image.size.height);
    
	[tempView addSubview:titleLabel];
	[tempView addSubview:pointView];
	
	[titleLabel release];
	[pointView release];
	
	return [tempView autorelease];
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Memory management

- (void)dealloc {
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

@end
