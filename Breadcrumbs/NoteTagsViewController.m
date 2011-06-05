//
//  NoteTagsViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteTagsViewController.h"
#import "Tag.h"
#import "NSManagedObjectContext_Autosave.h"

@interface NoteTagsViewController()
@property (nonatomic, retain) Note *note;
@end

@implementation NoteTagsViewController

@synthesize delegate;
@synthesize note;

- (id)initWithNote:(Note *)aNote {
    if (aNote) {
        self = [super initWithStyle:UITableViewStylePlain];
        if (self) {
            NSManagedObjectContext *context = [aNote managedObjectContext];
            
            NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
            request.entity = [NSEntityDescription entityForName:@"Tag"
                                         inManagedObjectContext:context];
            request.sortDescriptors = [NSArray arrayWithObject:
                                       [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                     ascending:YES
                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
            
            self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil] autorelease];
            
            self.note = aNote;
        }
    } else {
        [self release];
        self = nil;
    }
    return self;
}

- (void)dealloc {
    [note release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - CoreDataTableViewController customization

- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForManagedObject:(NSManagedObject *)managedObject {
    static NSString *reuseIdentifier = @"NoteTagsViewController.TagCell";
    
    Tag *tag = (Tag *)managedObject;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reuseIdentifier] autorelease];
        cell.imageView.image = [UIImage imageNamed:@"14-tag"];
    }
    cell.textLabel.text = tag.title;
    
    if ([self.note.tags containsObject:tag]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)didSelectManagedObject:(NSManagedObject *)managedObject {
    Tag *tag = (Tag *)managedObject;
    UITableViewCell *cell = [self tableView:self.tableView
                       cellForManagedObject:managedObject];
    
    NSMutableSet *tags = [[self.note.tags mutableCopy] autorelease];
    if ([tags containsObject:tag]) {    // remove tag
        [tags removeObject:tag];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {                            // add tag
        [tags addObject:tag];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    self.note.tags = tags;
    [NSManagedObjectContext autosave:[managedObject managedObjectContext]];
}

- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject {
    return NO;
}

#pragma mark - Button actions

- (void)done:(UIButton *)sender {
    [self.delegate dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"Add/remove tags";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(done:)] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
