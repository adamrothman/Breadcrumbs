//
//  NotesViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NotesViewController.h"
#import "Note_Create.h"
#import "NoteCell.h"
#import "NoteViewController.h"
#import "ActionSheetPicker.h"

@interface NotesViewController()
@property (nonatomic, retain) NSArray *sortDescriptorKeys;
@end

@implementation NotesViewController

@synthesize sortDescriptorKeys;

#pragma mark - Designated initializer

- (id)initWithStyle:(UITableViewStyle)style
inManagedObjectContext:(NSManagedObjectContext *)context {
    if (context) {
        self = [super initWithStyle:style];
        if (self) {
            NSString *key = [(NSString *)[self.sortDescriptorKeys objectAtIndex:0] lowercaseString];
            
            NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
            request.entity = [NSEntityDescription entityForName:@"Note"
                                         inManagedObjectContext:context];
            request.sortDescriptors = [NSArray arrayWithObject:
                                       [NSSortDescriptor sortDescriptorWithKey:key
                                                                     ascending:YES
                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
            self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil] autorelease];
            
            self.searchKey = key;
        }
    } else {
        [self release];
        self = nil;
    }
    
    return self;
}
                                           
#pragma mark - Properties

- (NSArray *)sortDescriptorKeys {
    if (!sortDescriptorKeys) {
        sortDescriptorKeys = [[NSArray alloc] initWithObjects:@"Title", @"Modified", @"Location", nil];
    }
    return sortDescriptorKeys;
}

#pragma mark - CoreDataTableViewController customization

- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForManagedObject:(NSManagedObject *)managedObject {
    static NSString *reuseIdentifier = @"NoteCell";
    
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
        NoteViewController *noteViewer = [[[NoteViewController alloc] initWithNote:(Note *)managedObject] autorelease];
        [self.navigationController pushViewController:noteViewer animated:YES];
    }
}

- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject {
    return YES;
}

- (void)didRemoveManagedObject:(NSManagedObject *)managedObject {
    NSLog(@"NYE: note removal");
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
    NSString *sample = @"Aenean facilisis nulla vitae urna tincidunt congue sed ut dui. Morbi malesuada nulla nec purus convallis consequat. Vivamus id mollis quam. Morbi ac commodo nulla. In condimentum orci id nisl volutpat bibendum. Quisque commodo hendrerit lorem quis egestas. Maecenas quis tortor arcu. Vivamus rutrum nunc non neque consectetur quis placerat neque lobortis. Nam vestibulum, arcu sodales feugiat consectetur, nisl orci bibendum elit, eu euismod magna sapien ut nibh. Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula egestas tincidunt. Nullam risus magna, ornare vitae varius eget, scelerisque a libero. Morbi eu porttitor ipsum. Nullam lorem nisi, posuere quis volutpat eget, luctus nec massa. Pellentesque aliquam lacinia tellus sit amet bibendum. Ut posuere justo in enim pretium scelerisque. Etiam ornare vehicula euismod. Vestibulum at risus augue. Sed non semper dolor. Sed fringilla consequat velit a porta. Pellentesque sed lectus pharetra ipsum ultricies commodo non sit amet velit. Suspendisse volutpat lobortis ipsum, in scelerisque nisi iaculis a. Duis pulvinar lacinia commodo. Integer in lorem id nibh luctus aliquam. Sed elementum, est ac sagittis porttitor, neque metus ultricies ante, in accumsan massa nisl non metus. Vivamus sagittis quam a lacus dictum tempor. Nullam in semper ipsum. Cras a est id massa malesuada tincidunt. Etiam a urna tellus. Ut rutrum vehicula dui, eu cursus magna tincidunt pretium. Donec malesuada accumsan quam, et commodo orci viverra et. Integer tincidunt sagittis lectus. Mauris ac ligula quis orci auctor tincidunt. Suspendisse odio justo, varius id posuere sit amet, iaculis sit amet orci. Suspendisse potenti. Suspendisse potenti. Aliquam erat volutpat. Sed posuere dignissim odio, nec cursus odio mollis et. Praesent cursus, orci ut dictum adipiscing, tellus ante porttitor leo, vel gravida lacus lorem vitae est. Duis ultricies feugiat ante nec aliquam. Maecenas varius, nulla vel fermentum semper, metus nibh bibendum nunc, vitae suscipit mauris velit ac nunc. Mauris nunc eros, egestas at vehicula tincidunt, commodo ac mauris. Nulla facilisi. Nunc eros sem, lobortis non pulvinar id, blandit in eros. In bibendum suscipit porta. Quisque vitae erat eget nulla cursus malesuada. Nulla venenatis feugiat quam, sed rutrum tellus suscipit quis. Aliquam placerat velit in quam imperdiet vel vehicula nulla interdum. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi commodo, ipsum sed pharetra gravida, orci magna rhoncus neque, id pulvinar odio lorem non turpis. Nullam sit amet enim. Suspendisse id velit vitae ligula volutpat condimentum. Aliquam erat volutpat. Sed quis velit. Nulla facilisi. Nulla libero. Vivamus pharetra posuere sapien. Nam consectetuer. Sed aliquam, nunc eget euismod ullamcorper, lectus nunc ullamcorper orci, fermentum bibendum enim nibh eget ipsum. Donec porttitor ligula eu dolor. Maecenas vitae nulla consequat libero cursus venenatis. Nam magna enim, accumsan eu, blandit sed, blandit a, eros. Quisque facilisis.";
    
    for (int i = 0; i < numberOfNotes; i++) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        
        int loc = [self randomIntFrom:0 to:[sample length] / 3];
        int len = [self randomIntFrom:10 to:[sample length] - loc];
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
}

#pragma mark - Button actions

- (void)sort:(UIBarButtonItem *)sender {
    [ActionSheetPicker displayActionPickerWithView:self.view
                                              data:self.sortDescriptorKeys
                                     selectedIndex:0
                                            target:self
                                            action:@selector(itemSelected:)
                                             title:@"Sort by..."];
}

- (void)itemSelected:(NSNumber *)selectedIndex {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    NSString *key = [(NSString *)[self.sortDescriptorKeys objectAtIndex:[selectedIndex unsignedIntegerValue]] lowercaseString];
    BOOL ascending;
    SEL comparator;
    if ([key isEqualToString:@"title"]) {
        ascending = YES;
        comparator = @selector(localizedCaseInsensitiveCompare:);
    } else if ([key isEqualToString:@"modified"]) {
        ascending = NO;
        comparator = @selector(compare:);
    } else if ([key isEqualToString:@"location"]) {
        // this isn't really right
        ascending = YES;
        comparator = @selector(localizedCaseInsensitiveCompare:);
    }
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:@"Note"
                                 inManagedObjectContext:context];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:key
                                                             ascending:ascending
                                                              selector:comparator]];
    
    self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                         managedObjectContext:context
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:nil] autorelease];
}

- (void)newNote:(UIBarButtonItem *)sender {
    // right now, just create a bunch of sample notes
    [self createSampleNotes:10];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"Notes";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Sort"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(sort:)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self
                                                                                            action:@selector(newNote:)] autorelease];
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
    [sortDescriptorKeys release];
    [super dealloc];
}

@end
