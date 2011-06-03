//
//  NoteTagsViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteTagsViewController.h"
#import "Tag.h"

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
        }
    } else {
        [self release];
        self = nil;
    }
    return self;
}

- (void)dealloc
{
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
    Tag *tag = (Tag *)managedObject;
    
    static NSString *reuseIdentifier = @"NoteTagsViewController.TagCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reuseIdentifier] autorelease];
        cell.imageView.image = [UIImage imageNamed:@"14-tag"];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = tag.title;
    
    return cell;
}

- (void)didSelectManagedObject:(NSManagedObject *)managedObject {
    Tag *tag = (Tag *)managedObject;
    
    NSLog(@"selected tag: %@", tag.title);
}

- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject {
    return NO;
}

#pragma mark - Button actions

- (void)done:(UIButton *)sender {
    [self.delegate modalDismiss:YES];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"Tags";
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
