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
#import "Attachment_Types.h"
#import "NoteCell.h"
#import "NoteViewController.h"
#import "ActionSheetPicker.h"

@interface NotesViewController()

@property (nonatomic, retain) NSArray *sortOptions;

@end

@implementation NotesViewController

@synthesize sortOptions;

#pragma mark - Designated initializer

- (id)initWithStyle:(UITableViewStyle)style
inManagedObjectContext:(NSManagedObjectContext *)context {
    if (context) {
        self = [super initWithStyle:style];
        if (self) {
            NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
            request.entity = [NSEntityDescription entityForName:@"Note"
                                         inManagedObjectContext:context];
            request.sortDescriptors = [NSArray arrayWithObject:
                                       [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                     ascending:YES
                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
            
            self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil] autorelease];
            
            self.searchKey = @"title";
            
            self.sortOptions = [NSArray arrayWithObjects:@"title", @"date", @"location", nil];
            
            self.tableView.scrollsToTop = YES;
            self.tableView.rowHeight = 64;
        }
    } else {
        [self release];
        self = nil;
    }
    
    return self;
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
        NoteViewController *noteViewer = [[[NoteViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        noteViewer.note = (Note *)managedObject;
        [self.navigationController pushViewController:noteViewer animated:YES];
    }
}

- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject {
    return NO;
}

- (void)didRemoveManagedObject:(NSManagedObject *)managedObject {
    // can't remove yet, so do nothing for now
}

#pragma mark - Testing tools

- (int)randomDoubleFrom:(double)low
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
        
        int loc = [self randomIntFrom:0 to:[sample length] - 10];
        int len = [self randomIntFrom:10 to:[sample length] - loc];
        [info setObject:[sample substringWithRange:NSMakeRange(loc, len)]
                 forKey:@"title"];
        
        [info setObject:sample
                 forKey:@"text"];
        
        int days = [self randomIntFrom:-730 to:730];
        [info setObject:[NSDate dateWithTimeIntervalSinceNow:days * 86400]
                 forKey:@"modified"];
        
        [info setObject:[[[CLLocation alloc] initWithLatitude:[self randomDoubleFrom:-90 to:90]
                                                    longitude:[self randomDoubleFrom:-180 to:180]] autorelease]
                 forKey:@"location"];
        
        [Note noteWithInfo:info inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    }
}

#pragma mark - Sort selection

- (void)sort:(UIBarButtonItem *)sender {
    [ActionSheetPicker displayActionPickerWithView:self.view
                                              data:self.sortOptions
                                     selectedIndex:0
                                            target:self
                                            action:@selector(itemSelected:)
                                             title:@"Sort by..."];
    
    // right now, just create a bunch of sample notes
    [self createSampleNotes:100];
}

- (void)itemSelected:(NSNumber *)selectedIndex {
    NSLog(@"selected: %@", [self.sortOptions objectAtIndex:[selectedIndex unsignedIntegerValue]]);
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"Notes";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Sort"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(sort:)] autorelease];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [sortOptions release];
    [super dealloc];
}

@end
