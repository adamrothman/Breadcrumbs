//
//  NoteBrowserViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteBrowserViewController.h"
#import "Note_Lifecycle.h"
#import "Tag_Create.h"
#import "NoteCell.h"
#import "NoteViewController.h"
#import "ActionSheetPicker.h"
#import "NSManagedObjectContext_Autosave.h"
#import "LocationMonitor.h"

@interface NoteBrowserViewController()
@property (nonatomic, retain) Tag *tag;
@property (nonatomic, retain) NSArray *sortOptions;
@end

@implementation NoteBrowserViewController

@synthesize tag, sortOptions;

#pragma mark - Designated initializer

- (id)initWithStyle:(UITableViewStyle)style
inManagedObjectContext:(NSManagedObjectContext *)context
             forTag:(Tag *)aTag {
    if (context) {
        self = [super initWithStyle:style];
        if (self) {
            NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
            request.entity = [NSEntityDescription entityForName:@"Note"
                                         inManagedObjectContext:context];
            if (aTag) {
                self.tag = aTag;
                request.predicate = [NSPredicate predicateWithFormat:@"tags contains[c] %@", self.tag];
            }
            request.sortDescriptors = [NSArray arrayWithObject:
                                       [NSSortDescriptor sortDescriptorWithKey:@"modified"
                                                                     ascending:YES
                                                                      selector:@selector(compare:)]];
            self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil] autorelease];
            
            self.searchKey = @"title";
        }
    } else {
        [self release];
        self = nil;
    }
    
    return self;
}
                                           
#pragma mark - Properties

- (NSArray *)sortOptions {
    if (!sortOptions) {
        sortOptions = [[NSArray alloc] initWithObjects:@"Last modified", @"Distance", @"Title", nil];
    }
    return sortOptions;
}

#pragma mark - Convenience

- (void)displayNote:(Note *)note {
    NoteViewController *noteViewer = [[[NoteViewController alloc] initWithNote:note] autorelease];
    [self.navigationController pushViewController:noteViewer
                                         animated:YES];
}

#pragma mark - CoreDataTableViewController customization

- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForManagedObject:(NSManagedObject *)managedObject {
    static NSString *reuseIdentifier = @"NoteBrowserViewController.NoteCell";
    
    NoteCell *cell = (NoteCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NoteCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    if ([managedObject isKindOfClass:[Note class]]) {
        cell.note = (Note *)managedObject;
    }
    
    return cell;
}

- (void)didSelectManagedObject:(NSManagedObject *)managedObject {
    if ([managedObject isKindOfClass:[Note class]]) {
        [self displayNote:(Note *)managedObject];
    }
}

- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject {
    return YES;
}

- (void)didRemoveManagedObject:(NSManagedObject *)managedObject {
    if ([managedObject isKindOfClass:[Note class]]) {
        [Note removeNote:(Note *)managedObject];
    }
}

#pragma mark - Testing tools

- (double)randomDoubleFrom:(double)low
                        to:(double)high {
    double multiplier = arc4random() / (pow(2, 32) - 1);
    return low + multiplier * (high - low);
}

- (int)randomIntFrom:(int)low
                  to:(int)high {
    return (int)[self randomDoubleFrom:low to:high];
}

- (void)createSampleNotes:(int)numberOfNotes {
    NSString *sample = @"Aenean facilisis nulla vitae urna tincidunt congue sed ut dui. Morbi malesuada nulla nec purus convallis consequat. Vivamus id mollis quam. Morbi ac commodo nulla. In condimentum orci id nisl volutpat bibendum. Quisque commodo hendrerit lorem quis egestas. Maecenas quis tortor arcu. Vivamus rutrum nunc non neque consectetur quis placerat neque lobortis. Nam vestibulum, arcu sodales feugiat consectetur, nisl orci bibendum elit, eu euismod magna sapien ut nibh. Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien.";
    
    for (int i = 0; i < numberOfNotes; i++) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        
        int loc = [self randomIntFrom:0 to:[sample length] - 25];
        int len = [self randomIntFrom:10 to:20];
        [info setObject:[sample substringWithRange:NSMakeRange(loc, len)]
                 forKey:@"title"];
        
        [info setObject:sample
                 forKey:@"text"];
        
        int days = [self randomIntFrom:-3 to:0];
        [info setObject:[NSDate dateWithTimeIntervalSinceNow:days * 86400]
                 forKey:@"modified"];
        
        [info setObject:[[[CLLocation alloc] initWithLatitude:37.42644 + [self randomDoubleFrom:-0.1 to:0.1]
                                                    longitude:-122.16331 + [self randomDoubleFrom:-0.1 to:0.1]] autorelease]
                 forKey:@"location"];
        
        [Note noteWithInfo:info inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    }
    
    [Tag tagWithTitle:@"food" inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    [Tag tagWithTitle:@"shopping" inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    [Tag tagWithTitle:@"errands" inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:5];
//    notification.alertBody = @"You have 1 nearby note.";
//    notification.alertAction = @"View";
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    [notification release];
}

#pragma mark - Button actions

- (void)itemSelected:(NSNumber *)selectedIndex {
    NSSortDescriptor *sortDescriptor;
    if ([selectedIndex integerValue] == 0) {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"modified"
                                                       ascending:NO
                                                        selector:@selector(compare:)];
    } else if ([selectedIndex integerValue] == 1) {
        CLLocation *currentLocation = nil;
        
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"location"
                                                       ascending:YES
                                                      comparator:^NSComparisonResult(id obj1, id obj2) {
                                                          CLLocationDistance dist1 = [(CLLocation *)obj1 distanceFromLocation:currentLocation];
                                                          CLLocationDistance dist2 = [(CLLocation *)obj2 distanceFromLocation:currentLocation];
                                                          
                                                          if (dist1 < dist2) {
                                                              return NSOrderedAscending;
                                                          } else if (dist1 == dist2) {
                                                              return NSOrderedSame;
                                                          } else {
                                                              return NSOrderedDescending;
                                                          }
                                                      }];
    } else if ([selectedIndex integerValue] == 2) {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                       ascending:YES
                                                        selector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:@"Note"
                                 inManagedObjectContext:context];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                         managedObjectContext:context
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:nil] autorelease];
}

- (void)sort:(UIBarButtonItem *)sender {
    [ActionSheetPicker displayActionPickerWithView:self.view
                                              data:self.sortOptions
                                     selectedIndex:0
                                            target:self
                                            action:@selector(itemSelected:)
                                             title:@"Sort by"];
}

- (void)newNote:(UIBarButtonItem *)sender {
    CLLocation *location = [LocationMonitor sharedMonitor].locationManager.location;
    NSDate *modified = [NSDate date];
    
    NSDictionary *newInfo = [NSDictionary dictionaryWithObjectsAndKeys:location, @"location", modified, @"modified", nil];
    
    Note *newNote = [Note noteWithInfo:newInfo
                inManagedObjectContext:[self.fetchedResultsController managedObjectContext]];
    [self displayNote:newNote];
    
    // create a bunch of sample notes for testing
    // [self createSampleNotes:10];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    UIBarButtonItem *sortButton = [[[UIBarButtonItem alloc] initWithTitle:@"Sort"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(sort:)] autorelease];
    if (self.tag) {
        self.navigationItem.title = self.tag.title;
        self.navigationItem.rightBarButtonItem = sortButton;
    } else {
        self.navigationItem.title = @"Notes";
        self.navigationItem.leftBarButtonItem = sortButton;
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                target:self
                                                                                                action:@selector(newNote:)] autorelease];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.scrollsToTop = YES;
    self.tableView.rowHeight = 64;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [tag release];
    [sortOptions release];
    [super dealloc];
}

@end
